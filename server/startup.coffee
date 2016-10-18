Meteor.startup ->
  ## 이메일 smtp 설정
  smtp =
    username : "meteorgsms"
    password : "!qazxsw2"
    server   : "smtp.gmail.com"
    port     : 587

  process.env.MAIL_URL = 'smtp://'+encodeURIComponent(smtp.username)+'%40gmail.com:'+encodeURIComponent(smtp.password)+'@'+encodeURIComponent(smtp.server)+':'+smtp.port