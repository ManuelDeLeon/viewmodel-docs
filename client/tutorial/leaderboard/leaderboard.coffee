

Template.leaderboard.onCreated ->
  Meteor.subscribe 'Players'

Template.leaderboard.viewmodel 'leaderboard',
    players: -> Players.find {}, { sort: { score:-1, name: 1 }, fields: { _id: 1 } }
    selected: null
    addPoints: -> Players.update @selected(), { $inc: { score: 5 } }
  , 'players'

Template.player.viewmodel ((c) -> c),
    player: -> Players.findOne(@_id())
    select: -> @parent().selected @_id()
    isSelected: -> @parent().selected() is @_id()
    info: -> @player().score + ' ' + @player().name

