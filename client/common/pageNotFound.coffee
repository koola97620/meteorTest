########################################
# init
########################################
sset 'timerPageNotFound', 3
timer = null

countDown = ->
  if sget('timerPageNotFound') is 1
    Meteor.clearInterval(timer)
    FlowRouter.go 'home'
    return

  num = sget('timerPageNotFound') - 1
  sset 'timerPageNotFound', num


########################################
# template
########################################
Template.pageNotFound.onCreated -> {}

Template.pageNotFound.onRendered ->
  timer = Meteor.setInterval(countDown, 1000)

Template.pageNotFound.helpers
  timerPageNotFound: ->
    return sget 'timerPageNotFound'

Template.pageNotFound.events {}
