############################################################
#                       router helper                      #  --> 추후 사용.
############################################################

checkLoggedIn = (redirect)->
  unless Meteor.userId()
    redirect 'index'

trackingPath = ()->
  sset 'currentPath', FlowRouter.current().path

# 알람 구독
subscribeNotice = (()->
  noticeSubs = undefined
  return () ->
    notSubscribed = noticeSubs == undefined
    existUserId = !!Meteor.userId()
    if notSubscribed and existUserId
      noticeSubs = Meteor.subscribe 'notice', Meteor.userId()
      console.log '## noticeSubscribed ##'
)()

FlowRouter.notFound =
  action : ->
    BlazeLayout.render 'pageNotFound'

############################################################
#                       router helper END                  #
############################################################

#####################초기 접속 화면###########################
FlowRouter.route '/',                                     #
  name : 'index'                                          #
  action : ->                                             #
    BlazeLayout.render 'index'                            #
###########################################################

FlowRouter.route '/signup',
  name : 'signup'
  action : ->
  ## 소셜을 통한 회원가입인지 아닌지를 비교하기 위해서 사용한다. 소셜 로긴, 소셜을 이용한 가입일 경우 토큰을 활용해 이용자 정보이용.
    getHash = location.hash.substr 1
    socialInfo = {}
    hashItems = getHash.split '&'
    for i in [0...hashItems.length]
      hashItem = hashItems[i].split '='
      socialInfo[hashItem[0]] = hashItem[1]

    BlazeLayout.render 'emptySignup', { content: 'signup', data: socialInfo }


###################로그인 후 이동되는 메인화면###################
FlowRouter.route '/home',                                #
  name : 'home'                                          #
  triggersEnter : [subscribeNotice]
  action : ->
    trackingPath()
    BlazeLayout.render 'mainLayout', { content : 'home'} #
##########################################################

FlowRouter.route '/createGroup',
  name : 'createGroup'
  triggersEnter : [checkLoggedIn, subscribeNotice]
  action : ->
    BlazeLayout.render 'mainLayout', { content : 'createGroup'}

FlowRouter.route '/feed', ##feed select시 id값을 넘겨줘서 queryparam으로 전달 router에서 분배.
  name : 'feed'
  triggersEnter : [checkLoggedIn, subscribeNotice]
  action : ->
    trackingPath()
    feedId = getQueryParam 'feedId'

    unless feedId
      BlazeLayout.render 'mainLayout', { content : 'Feed', data: sget('currentGroup')}
    else
      BlazeLayout.render 'mainLayout', { content : 'Feed_Content'}

FlowRouter.route '/scheduler',
  name : 'scheduler'
  triggersEnter : [checkLoggedIn, subscribeNotice]
  action : () ->
    trackingPath()
    if sget('currentGroup') == undefined
      FlowRouter.go 'home'
    else
      BlazeLayout.render 'mainLayout', { content : 'scheduler', data: sget('currentGroup') }