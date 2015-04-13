Template.dynamicVmParent.viewmodel({
  vmAnyEmail: function(){
    return EmailViewModel;
  },
  vmAcmeEmail: function(){
    return AcmeEmailViewModel;
  }
}, ['vmAnyEmail', 'vmAcmeEmail']);