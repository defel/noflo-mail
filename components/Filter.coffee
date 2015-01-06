noflo = require 'noflo'
selectn = require 'selectn'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'filter'
  c.description = 'filter mail by criteria'

  field = undefined
  accept = undefined
  regexp = undefined

  filterData = (object) ->
    newData = {}
    match = false
    return unless field

    value = selectn(field, object)

    console.log('VALUE ('+field+'): '+value)

    if accept
      if accept is value
        match = true

    if regexp
      r = new RegExp regexp
      if r.exec value
        match = true

    unless match
      return unless c.outPorts.missed.isAttached()
      c.outPorts.missed.send object
      c.outPorts.missed.disconnect()
      return

    c.outPorts.out.send object

  filtering = ->
    return field && (accept or regexp)

  mapField = ->
    switch field
      when "from"
        field = "from[0].address"
      when "to"
        field = "to[0].address"
      when "replyTo"
        field = "replyTo[0].address"

  # <- field
  c.inPorts.add 'field', datatype: 'string', (event, payload) ->
    switch event
      when "data"
        field = payload
        mapField()

  # <- accept
  c.inPorts.add 'accept', datatype: 'string', (event, payload) ->
    switch event
      when "data"
        accept = payload
  # <- regexp
  c.inPorts.add 'regexp', datatype: 'string', (event, payload) ->
    switch event
      when "data"
        regexp = payload
  # <- in
  c.inPorts.add 'in', datatype: 'object', (event, payload) ->
    switch event
      when "begingroup"
        c.outPorts.out.beginGroup payload
      when "data"
        return filterData payload if filtering()
        c.outPorts.out.send payload
      when "endgroup"
        c.outPorts.out.endGroup()
      when "disconnect"
        c.outPorts.out.disconnect()

  # -> out
  c.outPorts.add 'out',
    datatype: 'object'
  
  c.outPorts.add 'missed',
    datatype: 'object'
  
  # return component
  c
