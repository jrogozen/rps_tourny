'use strict';

var rpsApp = angular
  .module('rpsApp', [
    'ngRoute',
    'ngResource'
  ])

rpsApp.config(function ($routeProvider) {
  $routeProvider

  .when('/', {
    templateUrl: 'partials/home.html',
    controller: 'HomeController'
  })

  .when('/players', {
    templateUrl: 'partials/players.html',
    controller: 'PlayerListController'
  })
  .when('/players/new', {
    templateUrl: 'partials/player-add.html',
    controller: 'PlayerCreateController'
  })
  .when('/players/:id/edit', {
    templateUrl: 'partials/player-edit.html',
    controller: 'PlayerEditController'
  })
  .when('/players/:id', {
    templateUrl: 'partials/player-view.html',
    controller: 'PlayerViewController'
  })

  .when('/tournaments', {
    templateUrl: 'partials/tournaments.html',
    controller: 'TournamentsListController'
  })
  .when('/tournaments/new', {
    templateUrl: 'partials/tournaments-add.html',
    controller: 'TournamentsCreateController'
  })
  .when('/tournaments/:id', {
    templateUrl: 'partials/tournaments-view.html',
    controller: 'TournamentsViewController'
  })


  .when('/games', {
    templateUrl: 'partials/games.html',
    controller: 'GamesListController'
  })
  .when('/games/:id', {
    templateUrl: 'partials/game-view.html',
    controller: 'GamesViewController'
  })

});

// rpsApp.run(function ($http) {

// }