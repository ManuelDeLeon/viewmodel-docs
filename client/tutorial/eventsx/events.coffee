Template.eventsx.rendered = ->
  new ViewModel(
    outputMessage: -> console.log 'You clicked The Button (tm)'
  ).bind @
