Meteor.startup ->
  if Players.find().count() is 0
    names = [
      "Ada Lovelace"
      "Grace Hopper"
      "Marie Curie"
      "Carl Friedrich Gauss"
      "Nikola Tesla"
      "Claude Shannon"
    ]
    i = 0

    while i < names.length
      Players.insert
        name: names[i]
        score: Math.floor(Random.fraction() * 10) * 5

      i++
  return
