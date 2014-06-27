Postmaster
==========

Postmaster allows a child window that was opened from a parent window to
receive method calls from the parent window through the postMessage events.

Figure out who we should be listening to.

    dominant = opener or ((parent != window) and parent) or undefined

Bind postMessage events to methods.

    @Postmaster = (I={}, self={}) ->
      # Only listening to messages from `opener`
      addEventListener "message", (event) ->
        if event.source is dominant
          {method, params, id} = event.data

          try
            result = self[method](params...)

            send
              success:
                id: id
                result: result
          catch error
            send
              error:
                id: id
                message: error.message
                stack: error.stack

      addEventListener "unload", ->
        send
          status: "unload"

      # Tell our opener that we're ready
      send
        status: "ready"

      self.sendToParent = send

      return self

    send = (data) ->
      dominant?.postMessage data, "*"
