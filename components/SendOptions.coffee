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

  # host, port, secure

  hostResolver = Promise.defer()
  portResolver = Promise.defer()
  secureResolver = Promise.defer()

  promises = {
    host: hostResolver.promise,
    port: portResolver.promise,
    secure: secureResolver.promise
  }

  Promise.props(promises).then (options) ->
    console.log("OUT OPTS: ", options)
    c.outPorts.out.send(options)
    c.outPorts.out.disconnect()

  # Add input ports
  c.inPorts.add 'host',
    datatype: 'string'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        hostResolver.resolve(payload)

  c.inPorts.add 'port',
    datatype: 'string'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        portResolver.resolve(payload)

  c.inPorts.add 'secure',
    datatype: 'boolean'
    required: true
  , (event, payload) ->
    switch event
      when 'data'
        secureResolver.resolve(payload)
  
  # Add output ports
  c.outPorts.add 'out',
    datatype: 'object'

  # Finally return the component instance
  c
