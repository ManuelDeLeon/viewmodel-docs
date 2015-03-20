Template.stringArrayMultiple.viewmodel
  countries: ['France', 'Germany', 'Spain']
  selectedCountries: ['Germany', 'Spain']
  newCountry: ''
  addCountry: ->
    @countries().push @newCountry()
    @newCountry ''
  countryToSelect: ''
  selectCountry: ->
    if @countryToSelect() not in @selectedCountries()
      @selectedCountries().push @countryToSelect()
