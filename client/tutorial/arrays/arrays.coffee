Template.arrayList.viewmodel
  names: ['Tom', 'Dick', 'Harry']
  newName: ''
  addName: ->
    @names().push @newName()
    @newName ''
, 'names'

Template.arrayName.viewmodel (data) ->
  name: data
  remove: -> @parent().names().remove @name()


Template.arrayNumbers.viewmodel
  numberList: [2,3,1,9,3]
  numbers: -> @numberList().toString()
  sum: -> @numberList().reduce((t,s) -> t + s)
  newNumber: ''
  addNumber: ->
    @numberList().push parseInt(@newNumber())
    @newNumber ''
