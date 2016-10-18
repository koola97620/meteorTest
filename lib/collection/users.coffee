##########################################
#         Users Schema
#
# _id       : 식별아이디
# username  : 아이디
# email     : 이메일
# password  : 비밀번호
# profile   : {}
#   name       : 사용자이름
#   regPath    : 가입경로
#   friends    : [String] 친구목록
#   groups     : [String] 가입그룹
#   company    : 회사
#   department : 부서
##########################################

##########################################
#         Publish
##########################################

if Meteor.isServer
  Meteor.publish 'searchUsers', (searchQry)->
    return Meteor.users.find {$or : [{username: {$regex : searchQry} }, {'profile.name' :{$regex : searchQry}}] }

  Meteor.publish 'groupMembers', (memberList)->
    qry = _.map memberList, (userId)->
      obj = {_id : userId}
    return Meteor.users.find {$or : qry}

##########################################
#         Methods
##########################################
