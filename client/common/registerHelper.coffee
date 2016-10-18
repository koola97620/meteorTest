########################################
#         template helpers             #
########################################

Template.registerHelper 'isEqual', (v1, v2)->
  return v1 is v2

Template.registerHelper 'sget', (name)->
  return sget(name)

# 삼항 연산자
Template.registerHelper 'ternary', (predicate, v1, v2) ->
  return if predicate then v1 else v2

# 화면에 날짜 표시를 위한 함수 : current 가 참이면 '일'만 표시, 거짓이면 '월/일' 로 표시
Template.registerHelper 'dayFormat', (current, month, date) ->
  return if current then date else month + '/' + date

# 날자 형식변환
Template.registerHelper 'formatDate', (date)->
  return moment(date).format('YYYY.MM.DD')

# Array Count
Template.registerHelper 'arrayCount', (array)->
  return array.length