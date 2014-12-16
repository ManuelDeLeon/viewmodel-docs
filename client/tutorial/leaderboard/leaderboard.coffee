Template.leaderboard.created = ->
  Meteor.subscribe 'Players'
  this.vm = new ViewModel('leaderboard',
    players: -> Players.find {}, { sort: { score:-1, name: 1 }, fields: { _id: 1 } }
    selected: null
    addPoints: -> Players.update @selected(), { $inc: { score: 5 } }
  ).addHelper 'players', @

Template.leaderboard.rendered = ->
  this.vm.bind @

Template.player.rendered = ->
  new ViewModel(this.data).extend(
    player: -> Players.findOne(@_id())
    select: -> @parent().selected @_id()
    isSelected: -> @parent().selected() is @_id()
    info: -> @player().score + ' ' + @player().name
  ).bind @
