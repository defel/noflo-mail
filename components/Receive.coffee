noflo = require 'noflo'
mailin = require 'mailin'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'envelope'
  c.description = 'receive email'

  startMailin = (payload) =>
    console.log('START MAILIN: ', @port, @username, @password)
    mailin.start(payload)

  # <- options
  c.inPorts.add 'options', datatype: 'object', (event, payload) ->
    console.log('EVENT: ', event)

    switch event
      when "data"
        startMailin(payload)
        c.outPorts.status.send('#ffffff')

        mailin.on("message", (connection, data, content) ->
          #console.log('GOT MAIL: ', data.subject, data.text, data.html)
          c.outPorts.mail.send(data)
        )

  # -> out
  c.outPorts.add 'mail',
    datatype: 'object'
  
  c.outPorts.add 'status',
    datatype: 'color'
  
  c.outPorts.status.send('#ff0000')

  # return component
  c
