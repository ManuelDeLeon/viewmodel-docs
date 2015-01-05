Template.arrayList.created = ->
  this.vm = new ViewModel(
    names: ['Tom', 'Dick', 'Harry']
    newName: ''
    addName: ->
      @names().push @newName()
      @newName ''
  ).addHelper 'names', @

Template.arrayList.rendered = ->
  this.vm.bind @

Template.arrayName.rendered = ->
  new ViewModel(
    name: this.data
    remove: -> @parent().names().remove @name()
  ).bind @

Template.arrayNumbers.rendered = ->
  new ViewModel(
    numberList: [2,3,1,9,3]
    numbers: -> @numberList().toString()
    sum: -> @numberList().reduce((t,s) -> t + s)
    newNumber: ''
    addNumber: ->
      @numberList().push parseInt(@newNumber())
      @newNumber ''
  ).bind @