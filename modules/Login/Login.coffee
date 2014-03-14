angular.module('login').
factory('login', ($q, User, $rootScope) ->
  return {
    actualUser: {}

    session: require('session')
    users: require('users')

    getName: ->
      if this.isConnect()
        return this.actualUser.name
      else
        return ''

    signIn: (user, password) ->
      defer = $q.defer()
      _this = this
      User.getDoc({
        id: user
      }).then(
        (data) -> #Success
          _this.session.login(user, password, (err, response) ->
            if not err
              _this.actualUser = response
              $rootScope.$broadcast('SignIn')
              defer.resolve(response)
            else
              defer.reject(err)
          )
        ,(err) -> #Error
          defer.reject(err)
      )
      return defer.promise

    signUp: (user) ->
      defer = $q.defer()
      _this = this
      # Create the user inside _users db
      this.users.create(user.name, user.password, {}, (err, response) ->
        if err
          defer.reject(err)
        else
          # Create the user inside the db of the project
          User.update({
            _id:    ''
            update: 'create'
            name:   user.name
            email:  user.email
          }).then(
            (data) -> #Success
              # Sign In the user
              _this.signIn(user.name, user.password).then(
                (data) -> #Success
                  defer.resolve(data)
                ,(err) -> #Error
                  defer.reject(err)
              )

            ,(err) -> #Error
              defer.resolve(err)
          )
      )
      return defer.promise

    signOut: ->
      defer = $q.defer()
      _this = this
      this.session.logout( (err, response) ->
        if not err
          _this.actualUser = {
            name: response.name
            role: response.role
          }
          $rootScope.$broadcast('SignOut')
          defer.resolve(response)
        else
          defer.reject(err)
      )
      return defer.promise

    getInfo: ->
      defer = $q.defer()
      _this = this
      this.session.info( (err, info)->
        if not err
          info = info.userCtx
          _this.actualUser = info
          defer.resolve(info)
        else
          defer.reject(err)
      )
      return defer.promise

    isConnect: ->
      return this.actualUser.name? and this.actualUser.name != ''

    isNotConnect: ->
      return !this.isConnect()

    hasRole: (role) ->
      for piece in this.actualUser.roles
        if role == piece or piece == 'admin'
          return true
      # Otherwise
      return false
  }
)
