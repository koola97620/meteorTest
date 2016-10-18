# 템플릿 Method 시작
Template.groupSetting.onDestroyed ->
  if (this.searchSubscribe.stop)? then this.searchSubscribe.stop()
  if (this.searchTracker.stop)? then this.searchTracker.stop()
  if (this.memberSubscribe.stop)? then this.memberSubscribe.stop()

Template.groupSetting.onCreated ->

  this.searchValue = new ReactiveVar("!!!")
  this.memberSubscribe = ""
  this.searchSubscribe = ""
  this.searchTracker = ""

Template.groupSetting.onRendered -> {}

Template.groupSetting.helpers
  searchResultCount: ->
    return if (Meteor.users.find({_id : {$ne: Meteor.userId()}}).count() > 0) then true else false

  searchResult: ->
    return Meteor.users.find({_id : {$ne: Meteor.userId()}})

  groupInfo: ->
    return [sget 'currentGroup']

  isSearch: ->
    return Template.instance().searchValue.get()is "!!!"

  isPrivate: (boolVal)->
    return if boolVal is true then "비공개" else "공개"

Template.groupSetting.events

  'click .tablinks': (e, instance)->
    selectTab = $(e.target).data("value")
    if selectTab is "page3"
      if (instance.memberSubscribe.stop)? then instance.memberSubscribe.stop()
      instance.searchTracker = Tracker.autorun ()->
        instance.searchSubscribe = Meteor.subscribe 'searchUsers', instance.searchValue.get()
    else if selectTab is "page2"
      if (instance.searchSubscribe.stop)? then instance.searchSubscribe.stop()
      if (instance.searchTracker.stop)? then instance.searchTracker.stop()
      instance.memberSubscribe = Meteor.subscribe 'groupMembers', sget('currentGroup').members
    tabcontent = document.getElementsByClassName("tabcontent")
    for i in [0..tabcontent.length]
      $(tabcontent[i]).attr "style", "display: none;"

    tablinks = document.getElementsByClassName("tablinks")
    for j in [0..tablinks.length]
      $(tablinks[j]).removeClass "active"

    $('#'+selectTab).attr("style", "display: block;")
    $(e.currentTarget).addClass "active"


  ## Search Users
  'keyup #memberSearch': (e, instance)->
    e.preventDefault()
    searchValue = $('#memberSearch').val()
    if searchValue is ""
      return instance.searchValue.set '!!!'
    else
      instance.searchValue.set searchValue

  'click .input-field.col.s6 > i': (e, instance)->
    $('#memberSearch').val("")
    instance.searchValue.set '!!!'


  ## 회원미가입자 초대메일 발송..
  'click #inviteEmail': (e, instance)->
    groupInfo = sget 'currentGroup'
    email = $('#memberSearch').val()
    Meteor.call 'inviteEmail', email, groupInfo, (err, res) ->
      if err then return console.log 'err', err
      alert '메일 발송성공'


  ## 가입 회원 그룹 초대
  'click .btnInvite': (e, instance) ->
    group = sget 'currentGroup'
    inviteeId = Blaze.getData(e.currentTarget)._id
    Meteor.Notice.invite(group, inviteeId)

# 템플릿 Method 종료