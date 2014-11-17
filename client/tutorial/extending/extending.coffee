ViewModel.addBind 'fade', (p) ->
  p.autorun ->
    if p.vm[p.property]()
      p.element.fadeIn()
    else
      p.element.fadeOut()

Template.extending.rendered = ->
  new ViewModel(
    textFade: true
    toggleFade: -> @textFade !@textFade()
  ).bind @
