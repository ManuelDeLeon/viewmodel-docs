Template.emailCheck.viewmodel(
  EmailViewModel,
  // Extend the viewmodel
  {
    info: '',
    checkEmail: function() {
      var newInfo;
      if (this.invalidEmail()) {
        newInfo = this.message();
      } else {
        newInfo = "Email is valid!";
      }
      this.info( newInfo );
    },
    clearInfo: function(){
      this.info( '' );
    }
  }
);