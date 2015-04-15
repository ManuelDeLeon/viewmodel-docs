Template.commResults.viewmodel({
  search: function(){
    return ViewModel.byId("commSearchBox").searchText();
  }
})