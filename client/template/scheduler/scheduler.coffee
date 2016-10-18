#{ Calendar }  = require './calendar.coffee'
#{ scheduler } = require '../../../lib/collection/scheduler.coffee'

###
  Scheduler :  달력 정보를 입력받아 스케쥴러 UI 구성에 필요한 스케쥴 정보를 생성한다.

  @param
    calendar ( default: current year-month calendar )

  @method
    < 스케쥴 관련 >
    schedule: 스케쥴 정보 컬렉션
    add(data) : 스케쥴 신규 등록
    edit(data) : 스케쥴 수정
    delete(id) : 스케쥴 삭제

    < 달력 관련 >
    calendar: 주차별/일자별 달력 정보
    year: 년도
    month:  월
    dayNames : [ 일, 월, 화, 수, 목, 금, 토 ]

###
Scheduler = (calendar) ->

  list = calendar.list()
  groupId = sget('currentGroup')._id
  cursor  = scheduler.find({  $or: [
    {groupId:groupId, year:calendar.year, month:calendar.month}
    {groupId:groupId, year:calendar.prevYear(), month:calendar.prevMonth()}
    {groupId:groupId, year:calendar.nextYear(), month:calendar.nextMonth()} ]  })
  schedule = cursor.fetch()

  findSchedule = (s) ->
    ymd = s.year + '-' + s.month + '-' + s.day
    j = 0
    while j < list.length
      week = list[j].week
      k = 0
      while k < week.length
        w = week[k]
        if ymd == w.ymd
          return w
        k++
      j++
    return

  addSchedule = (s) ->
    i = 0
    unless s instanceof Array
      s = [s]
    while i < s.length
      f = findSchedule( s[i] );
      if f != undefined
        if f.schedule == undefined
          f.schedule = []
        f.schedule.push s[i]
        s[i].holiday = f.holiday # 화면단에서 scheudle 목록을 뿌려줄 때 holiday 값에 따라 다른 css 를 적용하기 위해 schedule 목록에 holiday 값 추가
      i++

  # 달력에 스케쥴이 등록된 일자들을 찾아 해당 일자에 스케쥴정보를 추가한다.
  addSchedule(schedule)

  {
    year: calendar.year
    month: calendar.month
    dayNames : calendar.dayNames
    calendar: list                   # 스케쥴 정보가 추가된 달력 목록
    schedule: schedule
    add : (doc, callback) ->
      Meteor.call 'insertDoc', 'scheduler', doc, callback
    edit : (id, doc, callback) ->
      Meteor.call 'updateDoc', 'scheduler', id, doc, callback
    delete : (id, callback) ->
      Meteor.call 'removeDoc', 'scheduler', id, callback
  }


###
  템플릿 시작
###
Template.scheduler.onCreated ->
  # 서버로 부터 scheduler Collection 에 변경이 있을경우 통보 받음
  groupId = this.data._id
  userId = Meteor.userId()
  this.subscribe 'scheduler', groupId
  this.subscribe 'notice', groupId, userId

  this.calendar = new ReactiveVar( Calendar() )
  this.scheduler = new ReactiveVar( Scheduler(this.calendar.get()) )

Template.scheduler.helpers
  # scheduler Collection 변경이 있을 시 호출
  scheduler: -> Scheduler( Template.instance().calendar.get() )
  group: -> sget 'currentGroup'
  notice: -> Notice.find()

Template.scheduler.events

# 이전달 스케쥴 조회 버튼 클릭 시
  'click #btnPrev': (event, instance) ->
    event.preventDefault
    instance.calendar.set instance.calendar.get().prev()
    # scheduler Collection 의 변경과 별개로 scheduler 객체에 이전달 스케쥴 정보를 적용하기 위함
    instance.scheduler.set Scheduler( Template.instance().calendar.get() )

# 다음달 스케쥴 조회 버튼 클릭 시
  'click #btnNext': (event, instance) ->
    event.preventDefault
    instance.calendar.set instance.calendar.get().next()
    # scheduler Collection 의 변경과 별개로 scheduler 객체에 다음달 스케쥴 정보를 적용하기 위함
    instance.scheduler.set Scheduler( Template.instance().calendar.get() )

# 일자 클릭 시 신규 등록 폼 표시
  'click .btnAddForm': (event, instance) ->
    event.preventDefault
    data = Blaze.getData(event.currentTarget)
    $('#modalAdd-' + data.ymd).openModal()

# 스케쥴 신규 등록 버튼 클릭 시
  'click .btnAdd': (event, instance) ->
    event.preventDefault
    # TODO parameter validation
    data = Blaze.getData(event.currentTarget)
    ymd = data.ymd
    doc = {}
    doc.year = data.year
    doc.month = data.month
    doc.day = data.date
    doc.title = instance.find('#txtTitle-' + ymd).value
    doc.detail = instance.find('#txtDetail-' + ymd).value
    doc.groupId = instance.data._id
    doc.createdAt = new Date()
    doc.regId = Meteor.userId()

    instance.scheduler.get().add(doc, (err, result) ->
      if err
        console.log err
      else
        alert '스케쥴 등록 완료'
        instance.find('#txtTitle-' + ymd).value = ''
        instance.find('#txtDetail-' + ymd).value = ''
        $('#modalAdd-' + ymd).closeModal()
    )

# 스케쥴 클릭 시 상세 조회/수정 폼 표시
  'click .btnView': (event, instance) ->
    event.preventDefault
    data = Blaze.getData(event.currentTarget)
    $('#modalView-' + data._id).openModal()

# 스케쥴 수정 버튼 클릭 시
  'click .btnEdit': (event, instance) ->
    event.preventDefault
    data = Blaze.getData(event.currentTarget)
    id = data._id
    doc = {}
    doc.title = instance.find('#txtTitle-' + id).value
    doc.detail = instance.find('#txtDetail-' + id).value
    doc.updatedAt = new Date()
    doc.updateId = Meteor.userId()

    instance.scheduler.get().edit(id, doc, (err, result) ->
      if err
        console.log err
      else
        alert '스케쥴 수정 완료'
        $('#modalView-' + id).closeModal()
    )

# 스케쥴 삭제 버튼 클릭 시
  'click .btnDel': (event, instance) ->
    event.preventDefault
    data = Blaze.getData(event.currentTarget)
    id = data._id

    instance.scheduler.get().delete(id, (err, result) ->
      if err
        console.log err
      else
        alert '스케쥴 삭제 완료'
    )
###
  템플릿 종료
###