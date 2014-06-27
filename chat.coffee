
# TODO: Post image to chat
# TODO: Autolink urls
# TODO: Base64 encode json env?

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
  .map (messageGroup) ->
    extend messageGroup, messageGroup[0]

    messageGroup.createdAt = moment(messageGroup[messageGroup.length - 1].createdAt).format()

    messageGroup

scrollToBottom = ->
  $(".messages").scrollTop $(".messages").prop("scrollHeight")

if Meteor.isClient
  # TODO V2: Validate data with signature
  if ENV.name
    author =
      name: ENV.name
      link: "http://pixieengine.com/#{ENV.name}"
      avatar: ENV.avatar or "http://pixieengine.com/avatars/thumb/missing.png"
      color: ENV.color or "#0017E3"
  else
    author =
      name: "Anonymous #{0|(Math.random() * 65536)}"
      link: "http://pixieengine.com"
      avatar: "http://pixieengine.com/avatars/thumb/missing.png"
      color: "hsl(#{0|(Math.random() * 360)}, 80%, 50%)"

  Meteor.call('updatePerson', author)

  setInterval ->
    Meteor.call('updatePerson', author)
  , 30 * 1000

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

  Template.message.rendered = ->
    autolink(@firstNode)
    scrollToBottom()

  Template.messageHeader.rendered = ->
    @$('time').timeago()

  Template.people.people = People.find()

if Meteor.isServer
  Meteor.startup ->
    Meteor.setInterval ->
      pruneMessages()
      pruneInactive()
    , 5 * 1000

    seed()

pruneMessages = ->
  console.log "Messages: " + Messages.find().count()

  lastToKeep = Messages.findOne {},
    skip: 50
    sort:
      createdAt: -1

  if lastToKeep
    Messages.remove
      createdAt:
        $lt: lastToKeep.createdAt

pruneInactive = ->
  console.log "People: " + People.find().count()

  People.remove
    lastActive:
      $lt: moment().subtract('minutes', 1).toDate()
