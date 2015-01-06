# noflo-mailin

receive email in nodejs noflo apps

# usage 

Use this lib in your nodejs runtime environment: 

```js
npm install --save noflo-mail
```

# components

All Components: 

## mail/Filter

Icon: filter

Description: filter mail by criteria

Ports: 
| in | field | string | the field in incoming Mail, to filter for |
| in | accepts | string | the accepted value on filtered field |
| in | regexp | string | the accepted regexp on filtered field | 
| in | in | object | the incoming mail to filter |
| out | out | object | passed if mail matches filter |
| out | missed | object | missed if mail does not match filter |

## mail/Mail

Icon: envelope-o

Description: mail

Ports:
| in | from | string | from field |
| in | to | string | to field |
| in | reply_to | string | reply_to field |
| in | subject | string | subject field |
| in | text | string | text field |
| in | html| string | html field |
| in | send | all | send mail to out-Port "mail" on incoming IIP |
| out | mail | object |  |

## mail/Receive

Icon: envelope

Description: receive email

Ports: 
| in | options | object | output of ReceiveOptions |
| out | mail | object| the received mail |

## mail/ReceiveOptions

Icon: gear

Description: options

Ports:
| in | port | string | the smtp server will listen on this port |
| in | username | string | username to auth |
| in | password | string | password to auth |
| out | out | object | the options |

## mail/Send

Icon: envelope

Description: send emails to

Ports:
| in | mail | object | email to send |
| in | options | object | smtp transport options  |
| out | out | object |  |

## mail/SendOptions

Icon: gear

Description: options

Ports:
| in | host | string | smtp server |
| in | port | string |smtp port |
| in | secure | boolean | should ssl be used |
| out | out | object | the options |