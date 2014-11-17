vm = new ViewModel
  textVisible: true
  toggleText: -> @textVisible !@textVisible()

Template.reactivity.created = ->
  vm.addHelpers 'reactivity'

Template.reactivity.rendered = ->
  vm.bind @



