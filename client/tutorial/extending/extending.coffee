ViewModel.addBind 'fade', (p) ->
  p.autorun ->
    if p.vm[p.property]()
      p.element.fadeIn()
    else
      p.element.fadeOut()

Template.extending.viewmodel
  textFade: true
  toggleFade: -> @textFade !@textFade()

