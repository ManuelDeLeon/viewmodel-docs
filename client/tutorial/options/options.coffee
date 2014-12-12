Template.options.rendered = ->
  new ViewModel(
    countries: ['France', 'Germany', 'Spain']
    selectedCountry: 'Germany'
    newCountry: ''
    addCountry: ->
      @countries().push @newCountry()
      @newCountry ''
    countryToSelect: ''
    selectCountry: -> @selectedCountry @countryToSelect()
  ).bind @
