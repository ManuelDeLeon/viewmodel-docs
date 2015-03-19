Meteor.publish "players", -> Players.find()

@Players.allow
  update: (userId, o, fields, modifier) -> true

Meteor.publish "contacts", -> Contacts.find()

@Contacts.allow
  insert: (userId, o) -> Contacts.find().count() < 10
  update: (userId, o, fields, modifier) -> true
  remove: (userId, o) -> true
