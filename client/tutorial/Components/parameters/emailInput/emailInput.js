Template.emailInput4.viewmodel(function (data) {
  var domain = data.domain;
  return {
    email: '',
    invalidEmail: function () {
      var emailRegex = new RegExp("^([\\w-]+(?:\\.[\\w-]+)*)@" + domain + "$", "i");
      return !(emailRegex.test(this.email()));
    },
    message: function () {
      return this.invalidEmail() ? "Not " + domain + " email" : "";
    }
  };
});