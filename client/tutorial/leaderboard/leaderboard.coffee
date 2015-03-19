

Template.leaderboard.onCreated ->
  this.subscribe 'players'

Template.leaderboard.viewmodel 'leaderboard',
  players: -> Players.find {}, { sort: { score:-1, name: 1 } }
  selected: null
  addPoints: -> Players.update @selected(), { $inc: { score: 5 } }
, 'players'

Template.player.viewmodel (data) ->
  id: data._id
  player: -> Players.findOne(@id())
  select: -> @parent().selected @id()
  isSelected: -> @parent().selected() is @id()
  info: -> @player().score + ' ' + @player().name

