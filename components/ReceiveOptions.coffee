noflo = require 'noflo'
Promise = require 'bluebird'

exports.getComponent = ->
  c = new noflo.Component

  # Define a meaningful icon for component from http://fontawesome.io/icons/
  c.icon = 'gear'

  # Provide a description on component usage
  c.description = 'options'
  
  sendOptions = =>
    return unless @port and @username and @password
    console.log('SEND OPTIONS', @port, @username, @password)

  portResolver = Promise.defer()
  usernameResolver = Promise.defer()
  passwordResolver = Promise.defer()

  promises = {
    port: portResolver.promise,
    username: usernameResolver.promise,
    password: passwordResolver.promise
  }

  Promise.props(promises).then (options) ->
    console.log('SEND OPTIONS')
    c.outPorts.out.send(options)
    c.outPorts.out.disconnect()

  # Add input ports
  c.inPorts.add 'port',
    datatype: 'string'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        portResolver.resolve(payload)

  c.inPorts.add 'username',
    datatype: 'string'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        usernameResolver.resolve(payload)

  c.inPorts.add 'password',
    datatype: 'string'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        passwordResolver.resolve(payload)
  
  # Add output ports
  c.outPorts.add 'out',
    datatype: 'object'

  # Finally return the component instance
  c
