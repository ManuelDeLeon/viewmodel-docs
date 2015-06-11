Template.contacts.onCreated ->
  this.subscribe 'contacts'

Template.contacts.viewmodel
  contactList: -> Contacts.find()
  name: ''
  number: ''
  canAddContact: -> !!@name() and !!@number() and Contacts.find().count() <= 10
  addContact: ->
    if @canAddContact()
      Contacts.insert { name: @name(), number: @number() }
      @name ''
      @number ''
  hoveringAddContact: false
  errorText: ->
    if @hoveringAddContact() and not @canAddContact()
      if Contacts.find().count() >= 10
        "Can't have more than 10 contacts"
      else
        "Name and Number are required"
    else
      ''
, 'contactList'

Template.contact.viewmodel ((data) -> data),
  contact: -> Contacts.findOne @_id()
  delete: -> Contacts.remove @_id()
  editMode: false
  numberFocus: false
  edit: ->
    @name @contact().name
    @number @contact().number
    @editMode true
    @numberFocus true
  showControls: false
  cancel: -> @editMode false
  canUpdate: -> !!@name() and !!@number()
  update: ->
    Contacts.update @_id(), { $set: { name: @name(), number: @number() } }
    @editMode false
