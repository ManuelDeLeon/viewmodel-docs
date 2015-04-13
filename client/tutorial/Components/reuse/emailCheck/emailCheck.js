Template.emailCheck.viewmodel(
  EmailViewModel,
  {
    info: '',
    checkEmail: function() {
      var newInfo = this.invalidEmail() ? this.message() : "Email is valid!";
      this.info( newInfo );
    },
    clearInfo: function(){
      this.info( '' );
    }
  }
);