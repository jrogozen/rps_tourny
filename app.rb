require 'active_record'
require 'active_record_tasks'
require 'sinatra'
# require 'sinatra/reloader' if development?
require 'json'
require 'pry-byebug'
require 'squeel'
require 'rock_pape_scis'

# require_relative 'lib/rps.rb'
require_relative 'config/environments.rb'

get '/' do
  if session[:user_id]
    erb :index
  else
    erb :index
  end
end


get '/api/players' do
  Player.all.to_json
end

post '/api/players' do
  ng_params = JSON.parse(request.body.read)
  puts "ng_params: #{ng_params}"

  if ng_params["password"] == ng_params["password_confirmation"]
    hashed_password = Player.encrypt(ng_params["password"])
    Player.create(username: ng_params["username"], hashed_password: hashed_password, email: ng_params["email"])
  end
end

get '/api/players/:id' do
  Player.find(params["id"]).to_json
end

put '/api/players/:id' do
  ng_params = JSON.parse(request.body.read)

  p = Player.find(params["id"])
  p.update(ng_params)
end

delete '/api/players/:id' do
  p = Player.find(params["id"])
  p.destroy
end

get '/api/players/:id/tournaments' do
  player = Player.find(params[:id])

  tournaments = []

  player.games.each do |game|
    tournaments << Tournament.where(id: game.tournament_id)
  end

  tournaments.flatten.to_json
end




get '/api/tournaments' do
  Tournament.all.to_json
end

post '/api/tournaments' do
  ng_params = JSON.parse(request.body.read)
  puts "ng_params #{ng_params}"

  players = ng_params["players"].shuffle

  if !(players.length % 2 == 0)
    halt 404
    # return error = {:error => "Must have even number of players"}.to_json
  end

  t = Tournament.new(
    name: ng_params["name"]
  )

  count = 1

  players.each do |player|

    x = Player.where{ username =~ "#{player}" }.first

    if x.nil?
      halt 404
    end
    # x ||= Player.create(username: player)

    if count % 2 != 0
      # create new game
      @g = Game.create
      # add player
      @g.players << x
    else
      @g.players << x
      t.games << @g
    end
    t.players << x
    count += 1
  end

  @g.save
  t.save

  return t.to_json
end

get '/api/tournaments/:id' do
  t = Tournament.find(params["id"])
  games = Game.where(tournament_id: params["id"])

  all_players = []

  tournament = {:games => Hash.new({}), :game_ids => []}

  games.each do |game|
    tournament[:games][game.id] = game.players
    # binding.pry
    tournament[:game_ids] << game.id
    all_players << game.players
  end

  tournament[:info] = t
  tournament[:players] = all_players.flatten

  tournament.to_json
end

put '/api/tournaments/:id' do
  ng_params = JSON.parse(request.body.read)

  t = Tournament.find(params["id"])
  t.update(ng_params)
end

delete '/api/tournaments/:id' do 
  t = Tournament.find(params["id"])
  t.destroy
end




get '/api/games' do
  result = Game.all.map do |game|
    hash = game.attributes
    hash["loser"] = Player.find(hash["loser"]).username if hash["loser"]
    hash["winner"] = Player.find(hash["winner"]).username if hash["winner"]
    hash
  end

  result.to_json
end

# # shouldn't be able to make a game outside of tournament
# post '/games/new' do
# end

get '/api/games/:id' do
  g = Game.find_by(id: params["id"])
  game = {}

  round = g.moves.count
  game[:players] = g.players
  game[:info] = g


  game[:info][:winner] = Player.find(game[:info][:winner]).username if g.winner
  
  new_moves = g.moves.map do |m|
    hash = m.attributes
    hash["player"] = Player.find(hash["player_id"]).username
    hash
  end

  game[:moves] = new_moves

  game.to_json
end

post '/api/games/:id' do
  ng_params = JSON.parse(request.body.read)
  puts "ng_params: #{ng_params}"

  g = Game.find_by(id: params["id"])
  p = Player.find(ng_params["player"]["id"])
  t = Tournament.find(g.tournament_id)

  if t.winner
    return g.to_json
  end
  
  players = g.players

  # fight
  # {
  #   :player_1 => {
  #     username: "jon", 
  #     move: "rock"
  #   }, 
  #   :player_2 => {
  #     username: "daniel", 
  #     move: "paper"
  #   }
  # }

  if (g.status == "active") 
    m = Move.new
    m.move = ng_params["move"]
    m.save

    p.moves << m
    g.moves << m
    g.status = p.id
    g.save
  elsif (g.status != p.id) && (g.status != "over")
    m = Move.new
    m.move = ng_params["move"]
    m.save

    p.moves << m
    g.moves << m

    all_moves = Move.where(game_id: g.id).last(2)

    player1 = {
      username: all_moves[0].player.username,
      move: all_moves[0].move
    }

    player2 = {
      username: all_moves[1].player.username,
      move: all_moves[1].move
    }

    puts player1.inspect
    puts player2.inspect

    possible_players = []
    possible_players << player1[:username]
    possible_players << player2[:username]

    result = g.fight(player1, player2)

    if result == "tie"
      g.status = "active"
      g.save
    else
      # set winner
      winner = Player.find_by(username: result)
      possible_players.delete(result)
      g.winner = winner
      winner.wins += 1

      # set loser
      loser = Player.find_by(username: possible_players[0])
      g.loser = loser
      loser.losses += 1

      # end game
      g.status = "over"

      # kick the player out of the tournament
      x = TournamentPlayer.find_by(tournament_id: t.id, player_id: loser.id)
      x.status = "eliminated"
      x.save

      g.save
      winner.save
      loser.save
    end
  end

  # check to see if all the games are "over" 
  all_games = Game.where(tournament_id: t.id)
  over_games = Game.where(tournament_id: t.id, status: "over")
  remaining_players = TournamentPlayer.where(tournament_id: t.id, status: "active")

  if (remaining_players.length == 1)
    t.winner = Player.find(remaining_players.first.player_id).username
    t.save
  elsif (all_games.length == over_games.length)
    # all games are over, make next round
    remaining_players.to_a.shuffle!

    count = 1

    remaining_players.each do |player|
      p = Player.find(player.player_id)

      if count % 2 != 0
        # create new game
        @g = Game.create

        # add player
        @g.players << p
      else
        @g.players << p 
        t.games << @g
      end
      count += 1

    end
    t.save
    @g.save
  end

  return g.to_json
end


