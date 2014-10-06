'use strict';

rpsApp.controller('PlayerListController', function ($scope, PlayerFactory) {
  $scope.players = PlayerFactory.query( function() {
    console.log($scope.players);
  });
});

rpsApp.controller('PlayerCreateController', function ($scope, $location, PlayerFactory) {
  $scope.player = new PlayerFactory();

  $scope.addPlayer = function () {
    $scope.player.$save(function() {
      $location.url('/players');
    });
  };
});

rpsApp.controller('PlayerViewController', function ($scope, $routeParams, $location, PlayerFactory, PlayerTournamentsFactory) {
  $scope.player = PlayerFactory.get({id: $routeParams.id}, function () {
    console.log('found post');
  });
  $scope.tournaments = PlayerTournamentsFactory.query({id: $routeParams.id}, function () {
    console.log('found tournaments');
  });
});

rpsApp.controller('PlayerEditController', function ($scope, $routeParams, $location, PlayerFactory) {
  $scope.updatePlayer = function () {
    $scope.player.$update(function () {
      $location.url('/players');
    });
  };

  $scope.deletePlayer = function () {
    $scope.player.$delete(function () {
      $location.url('/players');
    });
  };

  $scope.loadPlayer = function() {
    $scope.player = PlayerFactory.get({id: $routeParams.id});
  };

  $scope.loadPlayer();
});

rpsApp.controller('TournamentsListController', function ($scope, TournamentFactory) {
  $scope.tournaments = TournamentFactory.query( function () {
    console.log($scope.tournaments);
  });
});

rpsApp.controller('TournamentsCreateController', function ($scope, $location, TournamentFactory) {

  $scope.tournament = {};
  $scope.tournament.players = [];

  $scope.addTournament = function () {
    console.log($scope.tournament);

    TournamentFactory.saveTournament({}, $scope.tournament, 
    function(data) {
        // do something on success
        $location.url('/tournaments/' + data.id);
    }, function(errorResult) {
        // do something on error
        if(errorResult.status === 404) {     
          $location.url('/players/new');       
        }
    });
  }

});

rpsApp.controller('TournamentsViewController', function ($scope, $location, $routeParams, TournamentFactory) {

  $scope.tournament = TournamentFactory.get({id: $routeParams.id}, function () {
    console.log('found tournament');
    console.log($scope.tournament);
    //console.log($scope.tournament.info.winner);
    if ($scope.tournament.info.winner) {
      $('.winner').show();
    };
  });

});

rpsApp.controller('GamesListController', function ($scope, $filter, PlayerFactory, GameFactory) {

  $scope.games = GameFactory.query(function () {
    console.log($scope.games);
  });

  $scope.players = PlayerFactory.query(function () {
    console.log($scope.players);
  });
  

});

rpsApp.controller('GamesViewController', function ($scope, $route, $routeParams, $location, GameFactory) {

  $scope.game = GameFactory.get({id: $routeParams.id}, function (data) {
    console.log('found game');
    console.log($scope.game);

    if ($scope.game.info.winner) {
      $('.winner').show();
    };

  });

  $scope.move = {}

  $scope.makeMove = function(input, player) {
    console.log('attempting to save move');
    $scope.move['move'] = input;
    $scope.move['player'] = player;
    GameFactory.saveMove({id: $routeParams.id}, $scope.move);
    $location.url('/games');
  };

  $scope.processDivs = function() {
    if ($scope.game.info.status === "over") {
      $('.user-input').hide();
    } else {
      $.each($scope.game.players, function() {
        if (parseInt($scope.game.info.status) === parseInt($(this.id)[0])) {
          console.log('match');
          console.log('.user-input.user-id-' + $(this.id)[0]);
          $('.user-input.user-id-' + $(this.id)[0]).hide();
        }
      });
    }
  };

  $scope.$on('ngRepeatFinished', function (ngRepeatFinishedEvent) {
    $scope.processDivs();
  });

});

rpsApp.controller('HomeController', function ($scope, $location, PlayerFactory, GameFactory) {
  $scope.players = PlayerFactory.query( function () {
    console.log($scope.players);
  });
  $scope.order = 'wins';

});