dropdownInit = ()->
  $('.dropdown-button').dropdown
    inDuration: 300
    outDuration: 225
    hover: true
    gutter: 0
    belowOrigin: true
    alignment: 'left'

modalInitSetting = ()->
  $('.modal-trigger').leanModal()

# 알람 클릭 시 우측 사이드 네비바 형태로 알람 내역 표시
noticeNaviInit = ()->
  $('#btnNoticeNavi').sideNav({
    menuWidth: 500,
    edge: 'right',
    closeOnClick: false
  });

# 우측상단 클릭 시 로그인한 친구들 보여주고 채팅창 넘어가게 하기
chattingNaviInit = ()->
  $('#btnChattingNavi').sideNav({
    menuWidth: 300,
    edge: 'right',
    closeOnClick: false
  });

# 템플릿 Method 시작
Template.header.onCreated ->

  sset 'settingModal', false


Template.header.onRendered ->
  dropdownInit()
  modalInitSetting()
  noticeNaviInit()
  chattingNaviInit()

Template.header.helpers

  ## 현재 어느 페이지를 보고 있는지 추적
  currentPath : (path=sget('currentPath'))->
    return path is '/home'

  isJoin : (groupId= sget('currentGroup')._id )->
    if Groups.find({$and : [ {_id:groupId}, {members : Meteor.userId()}]}).count() is 1
      return false
    else
      return true

  isAdmin : ()->
    return if (Groups.find( {adminId : Meteor.userId()} ).count() is 1) then true else false

  user : ->
    return Meteor.user()

  sesstingModal: ()->
    return sget('settingModal')

  notice: ->
    Notice.find({}, {sort: {createdAt: -1}})

Template.header.events

  ## 나중에 하나로 리팩토링하기 가입 / 탈퇴
  'click #joinGroup': ()->
    Meteor.call 'arrayMethod', "groups", "push", (sget('currentGroup'))._id, "members", Meteor.userId(), (err, res) ->
      if err then return console.log 'err', err
      alert '가입완료'

  'click #leaveGroup': ()->
    Meteor.call 'arrayMethod', "groups", "pull", (sget('currentGroup'))._id, "members", Meteor.userId(), (err, res) ->
      if err then return console.log 'err', err
      alert '탈퇴완료'
      FlowRouter.go 'home'
  ## 나중에 하나로 리팩토링하기 가입 / 탈퇴

  'click #settingNav': ()->
    sset 'settingModal', true
    Meteor.setTimeout(
      ()->
        $('#groupSetting').openModal
          complete: ()-> sset 'settingModal', false
      , 100
    )

  'click #logout': ()->
    Meteor.logout (err)->
      unless err then FlowRouter.go 'index'

  ## 그룹 초대 수락: 수락한 사용자를 그룹 맴버로 추가하고 수락 결과를 초대자에게 통보한다.
  'click .btnAccept': (event)->
    notice = Blaze.getData(event.currentTarget)
    groupId = sget('currentGroup')._id
    Meteor.Notice.accept(notice, groupId)

  ## 그룹 초대 거절 : 거절 알람을 읾음 처리하고 거절 내역을 초대자에게 통보한다.
  'click .btnReject': (event)->
    invitorId = sget('currentGroup').adminId
    noticeId = Blaze.getData(event.currentTarget)._id
    Meteor.Notice.reject(invitorId, noticeId)
# 템플릿 Method 종료