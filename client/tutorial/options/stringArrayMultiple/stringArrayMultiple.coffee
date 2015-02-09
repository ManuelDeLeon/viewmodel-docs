Template.stringArrayMultiple.rendered = ->
  new ViewModel(
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
  ).bind @