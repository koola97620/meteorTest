##########################################
#         Notice Schema
#
# _id         : 식별아이디
# content     : 알람 내역
# sendId      ; 알람 보낸 사용자 id
# recvId      : 알람 받을 사용자 id
# isRead      : 알람 수신 여부
# createdAt   : 생성일
# work        : 작업 유형 ( scheduler, feed, ... )               - optional
# type        : CRUD 유형 ( insert, update, remove )             - optional
# isInvite    : 초대 알람 여부 ( 그룹 초대용 알람인 경우 true )  - optional
##########################################
@Notice = new Mongo.Collection 'notice'

##########################################
#             Allow/ Deny
##########################################
Notice.allow
  insert: -> return false
  remove: -> return false
  update: -> return false

##########################################
#               Methods
##########################################


###
  알람 등록
    @method
      hook: 스케쥴 등록/수정/삭제 시 알람 등록
      invite: 그룹 초대
      accept: 그룹 초대 수락
      reject: 그룹 초대 거절
###
Meteor.Notice = ( ->

  hookRegistered = {}
  tblName = {
    scheduler : '스케쥴'
    feed : '피드'
  }
  typeName = {
    insert : '등록'
    update : '변경'
    remove : '삭제'
  }

  return {

    ###
      스케쥴, 포스트 등록/수정/삭제 시 알람 등록
      현재 스케쥴 등록 시에만 알람 등록 처리 ...
      나머지는 추후 구현 예정 ...
    ###
    hook : (collection, type) ->
      name = collection._name
      unless hookRegistered[name]
        hookRegistered[name] = {}
      unless hookRegistered[name][type]
        if name == 'scheduler'
          collection.after[type] (id, doc) ->
            console.log '## orgDoc ## ', doc
            group = Groups.findOne( {_id: doc.groupId} )
            groupMembers = group.members
            _.each(groupMembers, (memberId) ->
              noticeDoc = {}
              noticeDoc.work = collection._name
              noticeDoc.type = type
              noticeDoc.event = tblName[name] + " " + typeName[type]
              noticeDoc.content = doc.title
              noticeDoc.sendId = group.adminId
              noticeDoc.recvId = memberId
              noticeDoc.isRead = false
              noticeDoc.createdAt = new Date()
              Notice.insert noticeDoc

              console.log 'notice => ', noticeDoc
            )
        hookRegistered[name][type] = true
        console.log '## hook registered ==> ', name, type

    ###
      그룹 초대 알람 등록
    ###
    invite : (group, receiverId) ->
      inviteNoticeDoc = {}
      inviteNoticeDoc.event = '그룹 초대'
      inviteNoticeDoc.content = group.name + ' 그룹에 참여 하시겠습니까?'
      inviteNoticeDoc.sendId = group.adminId
      inviteNoticeDoc.recvId = receiverId
      inviteNoticeDoc.isInvite = true
      inviteNoticeDoc.isRead = false
      inviteNoticeDoc.createdAt = new Date()

      console.log 'inviteNoticeDoc: ', inviteNoticeDoc

      Meteor.call 'insertDoc', 'notice', inviteNoticeDoc, (err, result) ->
        if err
          console.log err
        else
          alert '그룹 초대 요청 완료'


    ###
      그룹 초대 수락
    ###
    accept : (notice, groupId) ->
      acceptUserName = Meteor.user().username
      acceptorId = Meteor.userId()
      acceptNoticeDoc = {}
      acceptNoticeDoc.event = '초대 수락'
      acceptNoticeDoc.content = acceptUserName + '님이 그룹 초대를 수락하셨습니다.'
      acceptNoticeDoc.sendId = acceptorId
      acceptNoticeDoc.recvId = notice.sendId
      acceptNoticeDoc.isRead = false
      acceptNoticeDoc.createdAt = new Date()

      console.log 'acceptNoticeDoc: ', acceptNoticeDoc

      Meteor.call 'arrayMethod', 'groups', 'push', groupId, 'members', acceptorId, (err, result) ->
        if err
          console.log '## 그룹 멤버 추가 실패: ', err
        else
          Meteor.call 'insertDoc', 'notice', acceptNoticeDoc, (err, result) ->
            if err
              console.log '## 수락 알람 등록 실패: ', err
            else
              Meteor.call 'updateDoc', 'notice', notice._id, {isRead: true}, (err, result) ->
                  if err
                    console.log '## 초대 알람 수신 상태 갱신 실패: ', err
                  else
                    alert '그룹 초대 수락 완료'


    ###
      그룹 초대 거절
    ###
    reject : (invitorId, noticeId) ->
      rejectUserName = Meteor.user().username
      rejectNoticeDoc = {}
      rejectNoticeDoc.event = '초대 거절'
      rejectNoticeDoc.content = rejectUserName + '님이 그룹 초대를 거절하셨습니다.'
      rejectNoticeDoc.sendId = Meteor.userId()
      rejectNoticeDoc.recvId = invitorId
      rejectNoticeDoc.isRead = false
      rejectNoticeDoc.createdAt = new Date()

      console.log 'rejectNoticeDoc: ', rejectNoticeDoc

      Meteor.call 'insertDoc', 'notice', rejectNoticeDoc, (err, result) ->
        if err
          console.log '## 거절 알람 등록 실패: ', err
        else
          Meteor.call 'updateDoc', 'notice', noticeId, {isRead: true}, (err, result) ->
            if err
              console.log '## 거절 알람 수신 상태 갱신 실패: ', err
            else
              alert '그룹 초대 거절 완료'
  }
)()

##########################################
#               Publish
##########################################
if Meteor.isServer
  Meteor.publish 'notice', ( userId ) ->
    return Notice.find({recvId: userId, isRead: false}, {sort: {createdAt: -1}})


