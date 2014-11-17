@vm = new ViewModel
  arr: ["a", "b"]

Template.reactiveArrays.helpers
  arr: -> vm.arr()