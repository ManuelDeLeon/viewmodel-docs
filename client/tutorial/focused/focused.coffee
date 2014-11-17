Template.focused.rendered = ->
  new ViewModel(
    isFocused: false
    setFocus: -> @isFocused true
  ).bind @
