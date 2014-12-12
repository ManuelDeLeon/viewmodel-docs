Meteor.publish "Players", -> Players.find()

@Players.allow
  update: (userId, o, fields, modifier) -> true

Meteor.publish "Contacts", -> Contacts.find()

@Contacts.allow
  insert: (userId, o) -> Contacts.find().count() < 10
  update: (userId, o, fields, modifier) -> true
  remove: (userId, o) -> true