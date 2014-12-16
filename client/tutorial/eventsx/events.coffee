Template.eventsx.rendered = ->
  new ViewModel(
    outputMessage: (e) ->
      console.log 'You clicked The Button (tm)'
  ).bind @
