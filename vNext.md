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

Template.person.viewmodel({
  vmSharedTemplate: {
    name: ''
  },
  vmSharedChildren: {
    opportunities: []
  }
 })

```

```js
bc = { 
  vm, 
  getVmValue, // uses converters 
  setVmValue, // uses converters
  element, 
  elementBind, 
  templateInstance, 
  bindName,
  bindObject,
  converters, 
  autorun, 
  
}

ViewModel.addBind({
  bindName: 'value',
  elementSelector: 'input[type=text]',
  domEvents: {
    'input change': function() {
      
    },
    'keypress': function() {
      
    }
  },
  bindIf: function(bc) {
    return true;
  },
  bind: function() {
    
  }
  }
})

--

ViewModel.addBind({
  bindName: 'toggle',
  domEvents: {
    'click': function(bc) {
      var vmValue = bc.getVmValue();
      bc.setVmValue(!vmValue);
    }
  }
  }
})

--

ViewModel.addBind
  bindName: 'class'
  bindIf: (bc) -> _.isString(bc.bindObject)
  bind: (bc) ->
    
    
ViewModel.addBind
  bindName: 'class'
  bindIf: (bc) -> not _.isString(bc.bindObject)
  bind: (bc) ->
    for cssClass of bc.bindObject
      do(cssClass) ->
        bc.autorun ->
		  if bc.getVmValue(bc.bindObject[cssClass])
            p.element.addClass cssClass
          else
            p.element.removeClass cssClass

```
