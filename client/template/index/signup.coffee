regUser = ()->
  doc = {}
  doc.username = $('#username').val()
  doc.password = $('#password').val()
  doc.email = $('#email').val()
  profile = {}
  profile.name = $('#name').val()
  profile.company = $('#company').val()
  profile.department = $('#department').val()
  doc.profile = profile
  Accounts.createUser doc, (err)->
    if err
      console.log err
    else
      alert '회원가입성공'
      FlowRouter.go 'index'

# 템플릿 Method 시작
Template.signup.onCreated -> {}

Template.signup.onRendered -> {}

Template.signup.helpers

## 추후 소셜로긴 구분 후 데이터 값 세팅 ##

Template.signup.events
  'click #join': (e)->
    e.preventDefault()
    regUser()
# 템플릿 Method 종료