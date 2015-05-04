Template.objectArraySingle.viewmodel
  countries: [{ id: 1, name: 'France' }, { id: 2, name: 'Germany' }, { id: 3, name: 'Spain' }]
  selectedId: 2
  selectedName: -> _.findWhere(this.countries(), { id: Number(this.selectedId()) })?.name

