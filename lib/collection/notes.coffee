@notes = new Mongo.Collection 'notes'


###
  allow/ deny
###

## 테스트를 위해 임시로 허용 ##
if Meteor.isServer
  notes.allow
    insert : -> return true
## 테스트를 위해 임시로 허용 ##