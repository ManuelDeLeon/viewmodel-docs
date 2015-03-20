Template.stringArraySingle.viewmodel
  countries: ['France', 'Germany', 'Spain']
  selectedCountry: 'Germany'
  newCountry: ''
  addCountry: ->
    @countries().push @newCountry()
    @newCountry ''
  countryToSelect: ''
  selectCountry: -> @selectedCountry @countryToSelect()
