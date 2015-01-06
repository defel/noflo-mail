noflo = require 'noflo'
Promise = require 'bluebird'

exports.getComponent = ->
  c = new noflo.Component

  # Define a meaningful icon for component from http://fontawesome.io/icons/
  c.icon = 'envelope-o'

  # Provide a description on component usage
  c.description = 'mail'
  
  sendOptions = =>
    return unless @port and @username and @password
    console.log('SEND OPTIONS', @port, @username, @password)

  # from, to, replyTo, subject, text, html

  promises = {}
  mail = undefined

  ["from", "to", "reply_to", "subject", "text", "html"].forEach( (inPort) ->
    resolver = Promise.defer()
    promises[inPort] = resolver.promise

    c.inPorts.add inPort,
      datatype: 'string',
      required: true
    , (event, payload) ->
      switch event
        when "data"
          resolver.resolve(payload)
  )

  Promise.props(promises).then (props) ->
    mail =
      from: props.from,
      to: props.to,
      replyTo: props.reply_to,
      subject: props.subject,
      text: props.text,
      html: props.html
  
  c.inPorts.add "send",
    datatype: 'boolean'
  , (event, payload) ->
    switch event
      when "data"
        c.outPorts.mail.send(mail)

  # Add output ports
  c.outPorts.add 'mail',
    datatype: 'object'

  # Finally return the component instance
  c
