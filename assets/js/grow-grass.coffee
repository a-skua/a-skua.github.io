---
---
grow_grass = new Vue {
  delimiters: [
    '$'
    '$'
  ]
  el: '#grow-grass'
  template: '''
    <div>
      <p>$ count $</p>
      <div :style="style.wrapper">
        <template v-for="(v, k, i) in dates">
          <div
            :style="[bgColor(v.grass), {
              gridColumn: getGridColumn(i),
              gridRow: getGridRow(i)
            }]">
          </div>
          <div
            v-if="v.month"
            :style="{
              gridColumn: getGridColumn(i),
              gridRow: '1',
            }">
            $ v.month $
          </div>
          <div
            v-if="i < 7"
            :style="[style.week, {
              gridColumn: '1 / 4',
              gridRow: getGridRow(i)
            }]">
            <template v-if="i === 1">mon</template>
            <template v-if="i === 3">wed</template>
            <template v-if="i === 5">fri</template>
          </div>
        </template>
      </div>
    </div>
  '''
  data:
    count: 0
    rows_num: 8
    first_row_end: 2
    first_col_end: 4
    date_diff: 0
    start_date: ''
    end_date: ''
    dates: {}
    posts: {}
    style:
      wrapper:
        display: 'grid'
        gridGap: '2px'
        gridAutoColumns: 'minmax(1em, 1em)'
        gridAutoRows: 'minmax(1em, 1em)'
      item:
        less:
          backgroundColor: 'gray'
        one:
          backgroundColor: 'green'
        two:
          backgroundColor: 'green'
        more:
          backgroundColor: 'green'
      week:
        fontSize: '1em'
        textAlign: 'right'
  methods:
    bgColor: (num) ->
      switch num
        when 0
          this.style.item.less
        when 1
          this.style.item.one
        when 2
          this.style.item.two
        else
          this.style.item.more
    getDateColumn: (num) ->
      parseInt((num - 1) / this.rows_num) - 1
    getDateRow: (num) ->
      parseInt (num - 1) % this.rows_num
    getGridColumn: (num) ->
      parseInt(num / 7) + 4
    getGridRow: (num) ->
      num % 7 + 2
    getDateDiff: () ->
      start_date = this.getStartDate()
      end_date = this.getEndDate()
      date_diff = (end_date - start_date) / 24 / 60 / 60 / 1000

      this.start_date = start_date
      this.end_date = end_date
      parseInt(date_diff)
    getStartDate: () ->
      date = new Date()
      date.setFullYear date.getFullYear() - 1
      date.setMonth date.getMonth() + 1
      # date.setDate 1
      date.setDate date.getDate() - date.getDay()
      date.setHours 0
      date.setMinutes 0
      date.setSeconds 0
      date.setMilliseconds 0
      date
    getEndDate: () ->
      date = new Date()
      date.setDate date.getDate() + 1
      date.setHours 0
      date.setMinutes 0
      date.setSeconds 0
      date.setMilliseconds 0
      date
    getMonth: (num) ->
      switch num
        when 1
          'Feb'
        when 2
          'Mar'
        when 3
          'Apr'
        when 4
          'May'
        when 5
          'Jun'
        when 6
          'Jul'
        when 7
          'Aug'
        when 8
          'Sep'
        when 9
          'Oct'
        when 10
          'Nov'
        when 11
          'Dec'
        else
          'Jan'
    getJSON: () ->
      self = this
      xhr = new XMLHttpRequest()
      xhr.open 'GET', '{{ site.url }}/assets/json/posts_date.json', true
      xhr.onload = () ->
        if xhr.readyState == xhr.DONE
          if xhr.status == 200
            data = JSON.parse xhr.response
            for key, value of self.dates
              if data[key]
                len = data[key].length
                self.dates[key].grass = len
                self.count += len
      xhr.send null
      return
    setDates: () ->
      start_date = new Date this.start_date
      end_date = new Date this.end_date
      cnt = 0
      dates = {}
      month = null
      while start_date.getTime() != end_date.getTime()
        d = new Date start_date
        ymd = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice -2

        if cnt == 0 && d.getDate() < 15
          month = this.getMonth d.getMonth()

        dates[ymd] = {
          grass: 0
          month: month
        }

        start_date.setDate start_date.getDate() + 1
        if d.getMonth() != start_date.getMonth()
          month = this.getMonth start_date.getMonth()
        else
          month = null
        cnt += 1
      this.dates = dates
      return
  mounted: () ->
    this.date_diff = this.getDateDiff()
    this.setDates()
    this.getJSON()
    return
}
