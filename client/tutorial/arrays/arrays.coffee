arrayListVM = new ViewModel
  names: ['Tom', 'Dick', 'Harry']
  newName: ''
  addName: ->
    @names().push @newName()
    @newName ''

Template.arrayList.rendered = ->
  arrayListVM.bind @

Template.arrayList.helpers
  names: -> arrayListVM.names()

Template.arrayName.rendered = ->
  new ViewModel(
    name: this.data
    remove: -> arrayListVM.names().remove @name()
  ).bind @


Template.arrayNumbers.rendered = ->
  new ViewModel(
    numberList: [2,3,1,9,3]
    numbers: -> @numberList().toString()
    average: ->
      length = @numberList().length
      return 0 if length is 0
      sum = 0
      sum += n for n in @numberList()
      sum / length
    newNumber: ''
    addNumber: ->
      @numberList().push parseInt(@newNumber())
      @newNumber ''
  ).bind @