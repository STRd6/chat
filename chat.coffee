Messages = new Meteor.Collection('messages')

if Meteor.isClient
  Template.hello.greeting = ->
    return "Welcome to chat."

  Template.chats.events
    'click button': ->
      # template data, if any, is available in 'this'
      console?.log("You pressed the button")
      val = $("input").val()
      Messages.insert body: val
      $('input').val('')

  Template.chats.messages = Messages.find()

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
