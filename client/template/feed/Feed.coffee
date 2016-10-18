feedsData = [
  {
    Topic: 'Best way to deploy/run on Raspberry Pi?'
    Category: 'mobile'
    color:'teal lighten-2'
    Users: 'subati'
    Replies:100
    Views : 2
    Activity : '2h'
  }
  {
    Topic: 'Should I buy a surface book to develop in meteor?'
    Category: 'announce'
    color:'#e57373'
    Users: 'Max Hodges'
    Replies:21
    Views : 23
    Activity : '1d'
  }
  {
    Topic: 'How to mongoimport and not use ObjectId in the _id fields'
    Category: 'help'
    color:'#4dd0e1'
    Users: 'sungwoncho'
    Replies:21
    Views : 24
    Activity : '2d'
  }
  {
    Topic: 'Best way to deploy/run on Raspberry Pi?'
    Category: 'mobile'
    color:'teal lighten-2'
    Users: 'subati'
    Replies:100
    Views : 2
    Activity : '2h'
  }
  {
    Topic: 'Should I buy a surface book to develop in meteor?'
    Category: 'announce'
    color:'#e57373'
    Users: 'Max Hodges'
    Replies:21
    Views : 23
    Activity : '1d'
  }
  {
    Topic: 'How to mongoimport and not use ObjectId in the _id fields'
    Category: 'help'
    color:'#4dd0e1'
    Users: 'sungwoncho'
    Replies:21
    Views : 24
    Activity : '2d'
  }

]
Template.Feed.helpers Feeds: feedsData

Template.Feed.rendered = ->
  $('select').material_select()
  $('.modal-trigger').leanModal()
  return

Template.Feed.events = 'click #feed-cancel': ->
  $('#modal1').closeModal();
  return
