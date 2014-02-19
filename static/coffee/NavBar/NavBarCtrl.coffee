ng.controller('NavBarCtrl', ($scope, login) ->
  # User Object
  $scope.loginform = {}
  $scope.user      = {}

  login.getInfo().then(
    (user) ->
      $scope.user = user
  )


  # LogOut User
  $scope.logout = ->
    login.logout().then(
    ) ->
      $scope.user = {}

  # login User
  $scope.login = ->
    user     = $scope.loginform.user
    password = $scope.loginform.password
    if login isnt '' and password isnt ''
      login.signin(user, password).then(
         (data)-> #Success
          $scope.user = data
          $scope.loginform.password = ''
          $scope.loginform.user = ''
        , -> #Error
          $scope.loginform.password = ''
      )

  $scope.userIsConnected = ->
    return login.isConnect()
)
