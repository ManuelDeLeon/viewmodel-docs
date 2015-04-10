Template.emailInput.viewmodel({
  email: '',
  invalidEmail: function(){
    var emailRegex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return !(emailRegex.test(this.email()));
  },
  message: function() {
    return this.invalidEmail() ? "Invalid Email" : "";
  }
});