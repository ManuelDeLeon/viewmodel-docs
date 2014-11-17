Template.loginBox.rendered = ->
  new ViewModel( 'loginBox',
    first: ''
    firstFocus: false
    last: ''
    greeting: -> "Hello #{@first()} #{@last()}"
    canEnter: -> !!@first() and !!@last()
    showError: false
    errorText: ->
      return '' if @canEnter() or not @showError()
      "Please enter your first and last name"
  ).bind @