AcmeEmailViewModel = {
  email: '',
  invalidEmail: function () {
    var emailRegex = /^([\w-]+(?:\.[\w-]+)*)@acme.com$/i;
    return !(emailRegex.test(this.email()));
  },
  message: function () {
    return this.invalidEmail() ? "Not an Acme email" : "";
  }
}