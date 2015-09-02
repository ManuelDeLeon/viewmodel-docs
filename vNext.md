```js
ViewModel.Shared({
  car: {
    color: 'red',
    speed: 55,
    vmEvents: {
      'click #ignition': function(){
        this.start();
      }
    }
  },
  road: function(data) {
    return {
      id: data.id,
      some: 'thing'
    }
  }
})

ViewModel.Components(
  person: {
    name: ''
  },
  avatar: function(data) {
    return {
      id: data.id,
      some: 'thing'
    }
  }
)

Template.husband.viewmodel({
  vmId: 'Alan',
  vmComponents: 'person',
  vmShared: 'car',
  greeting: function() {
    return "Mr. " + this.name();
  }
})

Template.wife.viewmodel(
  function(data){
    return {
      hobbie: data.hobbie
    }
  },
  {
    vmId: 'Berta',
    vmShared: ['car', 'house'],
    vmComponents: 'person',
    greeting: function() {
      return "Ms. " + this.name();
    }
  }
)


```
