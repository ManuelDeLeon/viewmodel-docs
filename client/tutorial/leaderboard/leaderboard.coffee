Template.leaderboard.created = ->
  Meteor.subscribe 'Players'
  this.vm = new ViewModel('leaderboard',
    players: ->
      playerList = []
      self = @
      Players.find({}, { sort: { score:-1, name: 1 }, fields: { _id: 1 } } ).forEach (p) ->
        p.leaderboard = self
        playerList.push p
      playerList
    selected: null
    addPoints: -> Players.update @selected(), { $inc: { score: 5 } }
  ).addHelper 'players', @

Template.leaderboard.rendered = ->
  this.vm.bind @

Template.player.rendered = ->
  new ViewModel(this.data).extend(
    player: -> Players.findOne(@_id())
    select: -> @leaderboard().selected @_id()
    isSelected: -> @leaderboard().selected() is @_id()
    info: -> @player().score + ' ' + @player().name
  ).bind @
