leaderboard = new ViewModel 'leaderboard',
  players: -> Players.find({}, { sort: { score:-1, name: 1 }, fields: { _id: 1 } } )
  selected: null
  addPoints: -> Players.update(@selected(), { $inc: { score: 5 } })

Template.leaderboard.helpers
  players: -> leaderboard.players()

Template.leaderboard.rendered = ->
  leaderboard.bind @

Template.player.rendered = ->
  new ViewModel(this.data).extend(
    player: -> Players.findOne(@_id())
    select: -> leaderboard.selected @_id()
    isSelected: -> leaderboard.selected() is @_id()
    info: -> @player().score + ' ' + @player().name
  ).bind @
