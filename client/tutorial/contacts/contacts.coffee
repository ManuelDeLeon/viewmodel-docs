Template.contacts.created = ->
  Meteor.subscribe 'Contacts'

Template.contacts.helpers
  contactList: -> Contacts.find()

Template.contacts.rendered = ->
  firstNode = $(this.firstNode)
  console.log firstNode.attr('data-id')
#  firstNode.attr 'data-id', Math.random()
#  console.log firstNode.attr('data-id')
  new ViewModel(
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
  ).bind @

Template.contact.rendered = ->

  new ViewModel(this.data).extend(
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
  ).bind @