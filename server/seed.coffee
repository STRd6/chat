@seed = ->
  [1..5].map ->
    person =
      name: "Anonymous #{0|(Math.random() * 65536)}"
      link: "http://pixieengine.com"
      avatar: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADZElEQVRYR62XT0hUQRzHf7tCZpaHKARBWmrLDkVFdAsiAs1LGx5CqTyVmV0sYYmgxIKIBctLVluHsELpIG2XUogIukVU1CFrE0MQouhgmRnka7+/9jfMznv7Zjaby743f37fz3znN/NmI1RiaWtr88wh6XQ6UmIY1d1poC66vq6OB78dGyP9WSKWChMKIMIipM9SBzDr8e4KUhQA4qbwwVM9RZ2+db67oA2ALhA+AJl1Mpmk+5mMslrETSGoBrUBwMWJAgBz1mLz85Eh2trQ7Ft70w69n+SJzQUFUEx8TyLBOrobYbkQlJxhEEUBzNmJpXpeBNUBOJVKFewQK4Ce7UHZjbq+TQPU+apVBRaL9XqIi1NoB6wtGdmBoMNFDwARKToEgl87OUmzDx4HwrmcDQoANgWBiPjhzEYFURnbws8QP9D+xVdvHlBOSyCdTAgAQLynf5DWrF5GkWg1eeONdORCLQNQ7CbXZbNZ6u5ooeuJ1+yGXqwAemcdYGbiBQdccuwnC6zrKOeu3xNrqaJxJz+Xtaf5913/HMXjcfpxeTEDi0toKwlAckLEEQwQFUc/UtnuXwpAoJdm3vPj74eLaPbKKhZHf4FwPgdMF3wA+RkXeGu8IBn/GwBiAwJWCozYjjYk3+2rKxSCiEt/WYJ/ckCWQaIjyP76bXwP4OXQ3BBhtN0ZfVawk2ziGON0H0DHXBIyADLdLNghKLkkdI4nMZwHePOfGODD+DeqGdnALmD2Uw1veHvybKLVzvGcAaL1k96h2DnC51mEMBgZj50hBWD4BtyYOE3zo7XOINaOzU9nvLtnv7IO9jogpobvKeGapr3sipwR+84sp6Htlda4Tg7gUJpuvUQCIBAVLx8RhAEyu3mXEkc7AKoGjjvdhkKTEOKwU4IKhCyHzEBsD+q3oF2AtTeD4r2Fmny7YJCGVR0cEFiXXAhcK5k9gqFIQHmXOvNdgKUdbtlcCL0VYwl0Ed/Ui1QA2EU8NAfQaOaBDUDPE9vMXXaB+guWA+H9bSv5WevdrNsxrIPvP6BEBpCU3EzDuBYEgMAKAhcSFFw6T3R1KdGLvb0kV3dcSLRiFbfmQD6Y97m8SsXt3FGHr556z30lqe/J339BKCvnpl3jcn8nSvkUi0geAGM9AOgFn+SwNTHb/gCB/Oowv1TU7gAAAABJRU5ErkJggg=="
      color: "hsl(#{0|(Math.random() * 360)}, 80%, 50%)"
      lastActive: moment().toDate()

    Meteor.call('updatePerson', person)

talk = ->
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
