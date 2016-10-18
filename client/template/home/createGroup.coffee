createGroup = ()->
  doc = {}
  doc.name = $('#name').val()
  doc.isPrivate = if ($(':radio[name="isPrivate"]:checked').val() is "true") then true else false
  doc.description = $('#description').val()
  doc.themecolor = '#'+$('#themeColor').val()
  doc.recommend = Number(0)
  doc.members = [Meteor.userId()]
  doc.adminId = Meteor.userId()
  doc.createdAt = new Date()

  ##before check is Private, if that it public should be check same name from Mongodb.
  if doc.isPrivate is false
    Meteor.call 'checkNameWhenPublic', doc.name, (err, res) ->
      if err then console.log err
      if res
        Meteor.call 'insertDoc', 'groups', doc, (err, result)->
          if err
            console.log err
          else
            alert '그룹생성완료'
            FlowRouter.go 'home'
        return true
      else
        alert '그룹 이름이 중복되었습니다'
        return false
  else
    Meteor.call 'insertDoc', 'groups', doc, (err, result)->
      if err
        console.log err
      else
        alert '그룹생성완료'
        FlowRouter.go 'home'

initColorPicker = () ->
  if Meteor.colored
    Meteor.colored()

# 템플릿 Method 시작
Template.createGroup.onCreated -> {}

Template.createGroup.onRendered ->
  initColorPicker()

Template.createGroup.helpers -> {}

Template.createGroup.events
  'click #create': ()->
    createGroup()

# 템플릿 Method 종료