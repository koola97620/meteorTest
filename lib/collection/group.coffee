##########################################
#         Groups Schema
#
# _id         : 식별아이디
# name        : 그룹이름
# isPrivate   : 공개여부 boolean
# description : 그룹설명
# members     : [String] 그룹맴버
# themecolor  : 그룹보드테마 (# 제외한 컬러코드)
# recommend   : 추천수 ( 공개그룹일경우에만)
# adminId     : 관리자Id
# createdAt   : 그룹생성일자
##########################################

@Groups = new Mongo.Collection 'groups'


##########################################
#             Allow/ Deny
##########################################

Groups.allow
  insert: -> return false
  remove: -> return false
  update: -> return false

##########################################
#               Publish
##########################################

if Meteor.isServer
  Meteor.publish 'joinGroups', (userId)->
    return Groups.find {members: userId}, {adminId: false}

  Meteor.publish 'publicGroups', (userId)->
    return Groups.find {$and : [{ members: {$nin : [userId]}}, {isPrivate: false}] }, {adminId: false}

  Meteor.publish 'currentGroupInfo', (groupId)->
    return Groups.find {_id:groupId}

##########################################
#               Methods
##########################################

if Meteor.isServer
  Meteor.methods

    ## 공개그룹일 경우 그룹 이름 중복검사 // 비공개는 중복검사 X
    checkNameWhenPublic: (groupName)->
      checkNameCount = Groups.find({name:groupName}).count()
      if (checkNameCount > 0) then false else true

    ## 팀원 초대 메일 Method
    inviteEmail: (email, groupInfo)->
      unless Meteor.userId() and groupInfo and email then Meteor.Error "Must Be Login"

      data = {}
      data.username = Meteor.user().profile.name
      data.groupId = groupInfo._id
      data.groupName = groupInfo.name
      data.groupDescription = groupInfo.description
      data.adminEmail = "test@test.co.kr"

      Email.send
        to : email
        from : data.adminEmail
        subject : '팀 초대 이메일 입니다. '+groupInfo.name+'에 초대되셨습니다.'
        html : SSR.render 'inviteEmail', data

    ## home에서 token값 유효성(해당 그룹의 존재유무)를 확인한다.
    tokenValidate : (groupId)->
      if (Groups.find({_id: groupId}).count() > 0) then true else false
