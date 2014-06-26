Messages = new Meteor.Collection('messages')
People = new Meteor.Collection('people')


# TODO: Ping to keep active

# Group by same author
clump = (list, criterion) ->
  groups = []
  lastType = undefined
  group = []

  list.forEach (item) ->
    currentType = criterion(item)
    if currentType != lastType
      lastType = currentType
      group = []
      groups.push group

      group.push item
    else
      group.push item

  return groups

Meteor.methods
  updatePerson: (author) ->
    author.lastActive = moment().toDate()
    People.upsert {name: author.name}, author

getMessages = ->
  messages = Messages.find {},
    limit: 50
    sort:
      createdAt: -1
  .fetch()

  clump messages.reverse(), (message) ->
    message.author?.name

scrollToBottom = ->
  $(".messages").scrollTop $(".messages").prop("scrollHeight")

if Meteor.isClient
  # TODO: Get author data from embedding context
  author =
    name: "Duder"
    link: "http://pixieengine.com/Duder"
    avatar: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADZElEQVRYR62XT0hUQRzHf7tCZpaHKARBWmrLDkVFdAsiAs1LGx5CqTyVmV0sYYmgxIKIBctLVluHsELpIG2XUogIukVU1CFrE0MQouhgmRnka7+/9jfMznv7Zjaby743f37fz3znN/NmI1RiaWtr88wh6XQ6UmIY1d1poC66vq6OB78dGyP9WSKWChMKIMIipM9SBzDr8e4KUhQA4qbwwVM9RZ2+db67oA2ALhA+AJl1Mpmk+5mMslrETSGoBrUBwMWJAgBz1mLz85Eh2trQ7Ft70w69n+SJzQUFUEx8TyLBOrobYbkQlJxhEEUBzNmJpXpeBNUBOJVKFewQK4Ce7UHZjbq+TQPU+apVBRaL9XqIi1NoB6wtGdmBoMNFDwARKToEgl87OUmzDx4HwrmcDQoANgWBiPjhzEYFURnbws8QP9D+xVdvHlBOSyCdTAgAQLynf5DWrF5GkWg1eeONdORCLQNQ7CbXZbNZ6u5ooeuJ1+yGXqwAemcdYGbiBQdccuwnC6zrKOeu3xNrqaJxJz+Xtaf5913/HMXjcfpxeTEDi0toKwlAckLEEQwQFUc/UtnuXwpAoJdm3vPj74eLaPbKKhZHf4FwPgdMF3wA+RkXeGu8IBn/GwBiAwJWCozYjjYk3+2rKxSCiEt/WYJ/ckCWQaIjyP76bXwP4OXQ3BBhtN0ZfVawk2ziGON0H0DHXBIyADLdLNghKLkkdI4nMZwHePOfGODD+DeqGdnALmD2Uw1veHvybKLVzvGcAaL1k96h2DnC51mEMBgZj50hBWD4BtyYOE3zo7XOINaOzU9nvLtnv7IO9jogpobvKeGapr3sipwR+84sp6Htlda4Tg7gUJpuvUQCIBAVLx8RhAEyu3mXEkc7AKoGjjvdhkKTEOKwU4IKhCyHzEBsD+q3oF2AtTeD4r2Fmny7YJCGVR0cEFiXXAhcK5k9gqFIQHmXOvNdgKUdbtlcCL0VYwl0Ed/Ui1QA2EU8NAfQaOaBDUDPE9vMXXaB+guWA+H9bSv5WevdrNsxrIPvP6BEBpCU3EzDuBYEgMAKAhcSFFw6T3R1KdGLvb0kV3dcSLRiFbfmQD6Y97m8SsXt3FGHr556z30lqe/J339BKCvnpl3jcn8nSvkUi0geAGM9AOgFn+SwNTHb/gCB/Oowv1TU7gAAAABJRU5ErkJggg=="
    color: "#0017E3"
    lastActive: moment().toDate()

  Meteor.call('updatePerson', author)

  Template.form.events
    'submit form': ->
      val = $("input").val()
      Messages.insert
        body: val
        createdAt: moment().toDate()
        author: author
      Meteor.call('updatePerson', author)
      $('input').val('')

      return false

  Template.messages.messages = getMessages

  Template.message.rendered = scrollToBottom

  Template.people.people = People.find()

if Meteor.isServer
  seed = ->
    [0..5].map ->
      person =
        name: "Duder#{(Math.random() * 256)|0}"
        link: "http://pixieengine.com/Duder"
        avatar: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADZElEQVRYR62XT0hUQRzHf7tCZpaHKARBWmrLDkVFdAsiAs1LGx5CqTyVmV0sYYmgxIKIBctLVluHsELpIG2XUogIukVU1CFrE0MQouhgmRnka7+/9jfMznv7Zjaby743f37fz3znN/NmI1RiaWtr88wh6XQ6UmIY1d1poC66vq6OB78dGyP9WSKWChMKIMIipM9SBzDr8e4KUhQA4qbwwVM9RZ2+db67oA2ALhA+AJl1Mpmk+5mMslrETSGoBrUBwMWJAgBz1mLz85Eh2trQ7Ft70w69n+SJzQUFUEx8TyLBOrobYbkQlJxhEEUBzNmJpXpeBNUBOJVKFewQK4Ce7UHZjbq+TQPU+apVBRaL9XqIi1NoB6wtGdmBoMNFDwARKToEgl87OUmzDx4HwrmcDQoANgWBiPjhzEYFURnbws8QP9D+xVdvHlBOSyCdTAgAQLynf5DWrF5GkWg1eeONdORCLQNQ7CbXZbNZ6u5ooeuJ1+yGXqwAemcdYGbiBQdccuwnC6zrKOeu3xNrqaJxJz+Xtaf5913/HMXjcfpxeTEDi0toKwlAckLEEQwQFUc/UtnuXwpAoJdm3vPj74eLaPbKKhZHf4FwPgdMF3wA+RkXeGu8IBn/GwBiAwJWCozYjjYk3+2rKxSCiEt/WYJ/ckCWQaIjyP76bXwP4OXQ3BBhtN0ZfVawk2ziGON0H0DHXBIyADLdLNghKLkkdI4nMZwHePOfGODD+DeqGdnALmD2Uw1veHvybKLVzvGcAaL1k96h2DnC51mEMBgZj50hBWD4BtyYOE3zo7XOINaOzU9nvLtnv7IO9jogpobvKeGapr3sipwR+84sp6Htlda4Tg7gUJpuvUQCIBAVLx8RhAEyu3mXEkc7AKoGjjvdhkKTEOKwU4IKhCyHzEBsD+q3oF2AtTeD4r2Fmny7YJCGVR0cEFiXXAhcK5k9gqFIQHmXOvNdgKUdbtlcCL0VYwl0Ed/Ui1QA2EU8NAfQaOaBDUDPE9vMXXaB+guWA+H9bSv5WevdrNsxrIPvP6BEBpCU3EzDuBYEgMAKAhcSFFw6T3R1KdGLvb0kV3dcSLRiFbfmQD6Y97m8SsXt3FGHr556z30lqe/J339BKCvnpl3jcn8nSvkUi0geAGM9AOgFn+SwNTHb/gCB/Oowv1TU7gAAAABJRU5ErkJggg=="
        color: "#0017E3"
        lastActive: moment().toDate()

      Meteor.call('updatePerson', person)

      talk = Meteor.bindEnvironment ->
        Messages.insert
          body: "heyy#{Math.random()}"
          createdAt: moment().toDate()
          author: person

        Meteor.call('updatePerson', person)

        setTimeout ->
          talk()
        , (Math.random() * 10000)|0

      talk()

  Meteor.startup ->
    # TODO: Schedule pruning old data
    # TODO: Schedule pruning inactive people
    setInterval ->
      pruneMessages()
      pruneInactive()
    , 3 * 1000

    seed()

pruneMessages = Meteor.bindEnvironment ->
  console.log "Messages: " + Messages.find().count()

  lastToKeep = Messages.findOne {},
    skip: 50
    sort:
      createdAt: -1

  if lastToKeep
    Messages.remove
      createdAt:
        $lt: lastToKeep.createdAt

pruneInactive = Meteor.bindEnvironment ->
  console.log "People: " + People.find().count()

  People.remove
    lastActive:
      $lt: moment().subtract('minutes', 1).toDate()
