rpsApp.factory('PlayerFactory', function ($resource) {
  return $resource('/api/players/:id', {id:'@id'}, {
    update: {method: 'PUT'},
    delete: {method: 'DELETE'}
  });
});

rpsApp.factory('PlayerTournamentsFactory', function ($resource) {
  return $resource('/api/players/:id/tournaments', {id:'@id'}, {
    query: {method: 'GET', isArray: true}
  });
});

rpsApp.factory('TournamentFactory', function ($resource) {
  return $resource('/api/tournaments/:id', {id:'@id'}, {
    query: {method: 'GET', isArray: true},
    saveTournament: {method: 'POST'}
  });
});

rpsApp.factory('GameFactory', function ($resource) {
  return $resource('/api/games/:id', {id:'@id'}, {
    query: {method: 'GET', isArray: true},
    saveMove: {method: 'POST'}
  });
});

rpsApp.directive('onFinishRender', function ($timeout) {
  return {
      restrict: 'A',
      link: function (scope, element, attr) {
          if (scope.$last === true) {
              $timeout(function () {
                  scope.$emit('ngRepeatFinished');
              });
          }
      }
  }
});