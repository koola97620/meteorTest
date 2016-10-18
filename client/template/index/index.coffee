############################################################
#                  social(SNS)을 SDK init                   #
############################################################
                  ## facebookSDK init ##
facebookSDK = ->
  window.fbAsyncInit = ->
    FB.init
      appId: '1761239917477990'
      xfbml: true
      version: 'v2.7'
    return

  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    if d.getElementById(id)
      return
    js = d.createElement(s)
    js.id = id
    js.src = '//connect.facebook.net/en_US/sdk.js'
    fjs.parentNode.insertBefore js, fjs
    return
  ) document, 'script', 'facebook-jssdk'

############################################################
#                  social(SNS)을 SDK init END               #
############################################################

############################################################
#                  social(SNS) function                    #
############################################################

##3 kakao Login
#kakaoLogin = ()->
#  Kakao.Auth.login
#    success : (authObj)->
#      BlazeLayout.render 'emptySignup', {content : 'signup', data : authObj}
#    fail : (err)->
#      console.log err


#@facebookLogin = ()->
#  FB.getLoginStatus (response)->
#    if response.status is 'connected'
#      FB.api '/me', (response)->
#        BlazeLayout.render 'emptySignup', {content : 'signup', data : response}

############################################################
#                  social(SNS) function END                #
############################################################

login = ()->
  email = $('#email').val()
  password = $('#password').val()
  Meteor.loginWithPassword email, password, (err)->
    if err
      console.log err
    else
      FlowRouter.go 'home'


# 템플릿 Method 시작
Template.index.onCreated ->

  facebookSDK()

Template.index.onRendered -> {}

Template.index.helpers

Template.index.events

  'click #login' : (e)->
    e.preventDefault();
    login()

  'click #signup' : (e)->
    e.preventDefault();
    FlowRouter.go 'signup'

# 템플릿 Method 종료