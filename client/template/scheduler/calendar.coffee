###
Calendar :  년, 월을 입력받아 해당 년 월의 달력 정보를 생성한다.

  @param:
  	year  ( deafult: current year )
    month ( default: current month )

  @method:
    2016년 9월
    주차  월 화 수 목 금 토 일
       1  28 29 30 31 01 02 03
       2  04 05 06 07 08 09 10
       3  11 12 13 14 15 16 17
       4  18 19 20 21 22 23 24
       5  25 26 27 28 29 30 01

    year         - 2016
    month        - 9
    dayNames     - [ 일, 월, 화, 수, 목, 금, 토 ]
    days         - 30  [ 2016년 9월의 총 일수  ]
    weeks        - 5  [ 2016년 9월이 총 몇주인지 ]
    day(1)       - 4, day(2) - 5, day(3) - 6, day(4) - 0, day(5) - 1  [ 해당일의 요일 번호 반환(0:일 ~ 6:토) ]
    dayName(1)   - 목, dayName(2) - 금, dayName(5) - 월
    week(1)      - 1, week(3) - 1, week(4) - 2, week(25) - 5  [ 해당일이 몇주차인지 반환 ]
    firstDay     - 4  [ 2016년 9월 1일의 요일 번호 ]
    lastDay      - 5  [ 2016년 9월 마지막일의 요일 번호 ]
    prevYear     - 2015
    nextYear     - 2017
    prevMonth    - 8
    nextMonth    - 10
    prev         - Calendar(2016, 8)   [ 전달의 달력 정보 반환 ]
    next         - Calendar(2016, 10)  [ 다음달의 달력 정보 반환 ]
    list         - 2016년 9월의 주차별/일자별 달력 정보를 리스트 형식으로 반환  [ 인덱스, 년, 월, 주차, 일, 요일번호, 요일명, 주말여부, 현재월여부 반환 ]
    each(action) - 일자별 달력 정보 리스트를 순회하면서 action 수행
      사용 예)
        var calendar  = Calendar(2016, 9);
        var logAction = function(o){ console.log(o.week); };
        calendar.each( logAction );
###
@Calendar = (year, month) ->
  today = new Date

  leapYear = (y) ->
    y % 4 == 0 and y % 100 != 0 or y % 400 == 0

  toObj = (o, i, d, c) ->
    {
      index: i
      year: o.year
      month: o.month
      week: o.week(d)
      date: d
      ymd: o.year + '-' + o.month + '-' + d
      day: o.day(d)
      dayName: o.dayName(d)
      holiday: o.day(d) == 0 or o.day(d) == 6
      current: c
    }

  year = Number(year) or today.getFullYear()
  month = Number(month) or today.getMonth() + 1
  daysOfFebruary = if leapYear(year) then 29 else 28
  daysOfMonth = [
    31
    daysOfFebruary
    31
    30
    31
    30
    31
    31
    30
    31
    30
    31
  ]
  dayNames = [
    '일'
    '월'
    '화'
    '수'
    '목'
    '금'
    '토'
  ]
  dateObj = new Date(year, month - 1)
  {
    year: year
    month: month
    dayNames: dayNames
    days: ->
      daysOfMonth[month - 1]
    weeks: ->
      Math.ceil (@firstDay() + @days()) / 7
    day: (date) ->
      (@firstDay() + date - 1) % 7
    dayName: (date) ->
      dayNames[@day(date)]
    week: (date) ->
      Math.ceil (@firstDay() + date) / 7
    firstDay: ->
      dateObj.getDay()
    lastDay: ->
      @day @days()
    prevYear: ->
      if month == 1 then year - 1 else year
    nextYear: ->
      if month == 12 then year + 1 else year
    prevMonth: ->
      if month == 1 then 12 else month - 1
    nextMonth: ->
      if month == 12 then 1 else month + 1
    prev: ->
      Calendar @prevYear(), @prevMonth()
    next: ->
      Calendar @nextYear(), @nextMonth()
    list: ->
      index = 0
      list = []
      week = undefined
      prev = @prev()

      addDateInfo = (obj, from, to, current) ->
        d = from
        while d <= to
          if index % 7 == 0
            week = []
            list.push week: week
          week.push toObj(obj, ++index, d, current)
          d++
        return

      addDateInfo prev, prev.days() - @firstDay() + 1, prev.days(), false
      addDateInfo this, 1, @days(), true
      addDateInfo @next(), 1, 6 - @lastDay(), false
      list
    each: (action) ->
      list = @iterator()
      i = 0
      while i < list.length
        action list[i]
        i++
      return

  }

#module.exports = { Calendar }