Meteor.startup ->
  ## kakaoSDK init ##
  kakaoSDK = ()->
    Kakao.init 'b2299e29a1651f007fabc4b5eaaf1886'

  ## init currentGroup ...
  sset 'currentGroup', 'init'
  Tracker.autorun ->
    Meteor.subscribe 'currentGroupInfo' ,sget('currentGroup')._id

  ## Group Board Color Observer
  Tracker.autorun ()->
    unless sget('currentPath') is '/home'
#      $('#background').attr "style", ("background-color:"+(sget('currentGroup')).themecolor)
      Materialize.fadeInImage('#background') ## 전환효과 -> Set Time 할수있으면 적용// or Include JS Edit..
    else
#      $('#background').attr "style", ("background-color:white")
  ## 적용하게 될 경우 색도 너무 촌스럽고 // 앞의 투명으로 된 색은 모두 배경색으로 변경되기때문에 디자인 변경 후 적용...

#  $('head').append '<script src="assets/js/jscolor.min.js" type="text/javascript" id="jscolorScript"></script>'