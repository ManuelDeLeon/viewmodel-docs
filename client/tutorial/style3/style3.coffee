Template.style3.rendered = ->
  new ViewModel(

    styleObject:
      color: 'blue'
      'font-weight': 'bold'

    textStyle: -> 'My style is = ' + JSON.stringify @styleObject()
  ).bind @
