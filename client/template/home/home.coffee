## 그룹 가입 초대링크로 접속시 발동 trigger
popupRegGroup = ()->
  token = location.hash
  token = token.replace('#','')
  Meteor.call 'tokenValidate', token, (err, res) ->
    if err then return console.log 'err', err
    if res
      if token or sget('inviteToken')
        if token then sset 'inviteToken', token
        unless Meteor.userId()
          alert '로그인 후 이용 하실 수 있습니다.'
          FlowRouter.go 'index'
        else
          $('#inviteModal').openModal()
    else
      return false


#  $('#inviteModal').openModal()


# 템플릿 Method 시작
Template.home.onCreated ->
  this.subscribe 'joinGroups', Meteor.userId()
  this.subscribe 'publicGroups'
  ##defalue paging...(4개씩)
  this.personalItem = new ReactiveVar(4)
  this.publicItem = new ReactiveVar(4)
  this.searchValue = new ReactiveVar({name: {$regex : /.*/} })

Template.home.onRendered ->

  popupRegGroup()

Template.home.helpers

  joinGroups : ->
    return Groups.find {members: Meteor.userId()}, {limit:Template.instance().personalItem.get()}

  publicGroups : ->
    return Groups.find {$and : [Template.instance().searchValue.get() ,{ members: {$nin : [Meteor.userId()]}}, {isPrivate: false}] }, {limit:Template.instance().publicItem.get()}

  privatePage : ->
    return if ((Groups.find({members:Meteor.userId()}).count()/Template.instance().personalItem.get()) >=1) then true else false

  publicPage : ->
    return if ((Groups.find({$and : [Template.instance().searchValue.get(),{ members: {$nin : [Meteor.userId()]}}, {isPrivate: false}] }).count()/Template.instance().publicItem.get()) >=1) then true else false

Template.home.events

  ## 그룹 선택시 선택한 그룹의 정보를 세팅한채로 feed로 이동.
  'click .enterGroup' : (e)->
    sset 'currentGroup', Blaze.getData e.currentTarget
    FlowRouter.go 'scheduler'

  'click .createGroup': (e)->
    e.preventDefault()
    FlowRouter.go 'createGroup'


  ## infinite paging
  'click #getMorePersonalItem': (e, instance)->
    e.preventDefault()
    instance.personalItem.set instance.personalItem.get()+4
    Materialize.fadeInImage('#privateGroup')

  'click #getMorePublicItem': (e, instance)->
    e.preventDefault()
    instance.publicItem.set instance.publicItem.get()+4
    Materialize.fadeInImage('#publicGroup')


  ## Search Public Groups
  'keyup #publicSearch': (e, instance)->
    e.preventDefault()
    searchValue = $('#publicSearch').val()
    if searchValue is ""
      return instance.searchValue.set { name: /.*/ }
    else
      instance.searchValue.set {name: {$regex : searchValue} }

  'click .input-field.col.s2 > i': (e, instance)->
    $('#publicSearch').val("")
    instance.searchValue.set { name: /.*/ }

  'click #acceptInvite': ()->
    sset 'currentGroup', (sget 'inviteToken')
    Meteor.call 'arrayMethod', "groups", "push", sget('inviteToken'), "members", Meteor.userId(), (err, res) ->
      if err then return console.log 'err', err
    sset 'currentGroup', {_id : sget('inviteToken')}
    delete Session.keys['inviteToken']
    FlowRouter.go 'scheduler'


# 템플릿 Method 종료