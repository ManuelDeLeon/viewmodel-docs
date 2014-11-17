Template.returnKey.rendered = ->
  new ViewModel(
    message: 'Can it be true?'
    logMessage: -> console.log @message()
  ).bind @
