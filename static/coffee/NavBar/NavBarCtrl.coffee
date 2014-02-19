ng.controller('NavBarCtrl', ($scope, login, $modal) ->
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
      ->
        $scope.user = {}
    )

  # login User
  $scope.login = ->
    user     = $scope.loginform.user
    password = $scope.loginform.password
    if user isnt undefined and password isnt undefined
      login.signIn(user, password).then(
         (data)-> #Success
          $scope.user = data
          $scope.loginform.password = ''
          $scope.loginform.user = ''
        , -> #Error
          $scope.loginform.password = ''
          $scope.addAlert('The username or/and password are/is not correct', 'danger')
      )

  $scope.userIsConnected = ->
    return login.isConnect()


  $scope.signup = ->
    modalSignUp = $modal.open({
      templateUrl: '../partials/signup.html'
      controller:  'SignUpCtrl'
    })

    modalSignUp.result.then(
      (data) ->
        $scope.user.name = data.name
    )
)
