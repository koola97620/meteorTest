##########################################
#         Scheduler Schema
#
# _id         : 식별아이디
# title       : 스케쥴 명
# detail      : 스케쥴 상세
# year        : 년
# month       : 월
# day         : 일
# regId       : 등록자 id
# groupId     : 등록자 groupId
# createdAt   : 생성일
##########################################
@scheduler = new Mongo.Collection 'scheduler'

##########################################
#             Allow/ Deny
##########################################
scheduler.allow
  insert: -> return false
  remove: -> return false
  update: -> return false

##########################################
#               Methods
##########################################

##########################################
#               Publish
##########################################
if Meteor.isServer
  Meteor.publish 'scheduler', (groupId) ->
    return scheduler.find( $and : [ {groupId:groupId} ] )


