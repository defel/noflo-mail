process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

noflo = require 'noflo'
mailer = require 'nodemailer'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'envelope'
  c.description = 'send emails to '
  transporter = undefined

  startMailer = (opts) =>
    console.log('START MAILER: ', @opts)
    
  # <- mail
  c.inPorts.add 'mail', datatype: 'object', (event, payload) ->
    switch event
      when "data"
        console.log('SEND MAIL: ', payload)
        
        transporter.sendMail(payload, (err, info) ->
          console.error(err) if err
          console.log("Mail send: ", info.response) if info.response
        ) if transporter

  # <- options
  c.inPorts.add 'options', datatype: 'object', (event, payload) ->
    console.log('EVENT: ', event)

    switch event
      when "data"
        console.log('mailer created', payload)
        transporter = mailer.createTransport(payload)

  # -> out
  c.outPorts.add 'out',
    datatype: 'object'
  
  # return component
  c
