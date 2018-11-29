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
        <template v-for="i in date_diff">
          <div
            v-if="i > 7"
            :style="[style.item, {
              gridColumn: getGridColumn(i),
              gridRow: getGridRow(i)
            }]">
            <template v-if="dates[getDateColumn(i)] && dates[getDateColumn(i)][getDateRow(i)]">0</template>
          </div>
          <div
            v-else
            :style="[style.week, {
              gridColumn: '1 / ' + first_col_end,
              gridRow: getGridRow(i)
            }]">
            <template v-if="i === 2">Mon</template>
            <template v-if="i === 4">Wed</template>
            <template v-if="i === 6">Fri</template>
          </div>
        </template>
      </div>
    </div>
  '''
  data:
    count: 0
    rows_num: 7
    first_row_end: 2
    first_col_end: 4
    date_diff: 0
    start_date: ''
    end_date: ''
    dates: []
    posts: {}
    style:
      wrapper:
        display: 'grid'
        gridGap: '2px'
        gridAutoColumns: 'minmax(1em, 1em)'
        gridAutoRows: 'minmax(1em, 1em)'
      item:
        backgroundColor: 'gray'
      week:
        fontSize: '1em'
        textAlign: 'right'
  methods:
    getDateColumn: (num) ->
      parseInt((num - 1) / this.rows_num) - 1
    getDateRow: (num) ->
      parseInt (num - 1) % this.rows_num
    getGridColumn: (num) ->
      parseInt((num - 1) / this.rows_num) + this.first_col_end - 1
    getGridRow: (num) ->
      position = num % this.rows_num
      if position == 0 then 7 else position
    getDateDiff: () ->
      start_date = this.getStartDate()
      end_date = this.getEndDate()
      date_diff = (end_date - start_date) / 24 / 60 / 60 / 1000 + 7

      this.start_date = start_date
      this.end_date = end_date
      parseInt(date_diff)
    getStartDate: () ->
      date = new Date()
      date.setFullYear date.getFullYear() - 1
      date.setMonth if date.getMonth() == 11 then 0 else date.getMonth() + 1
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
    getJSON: () ->
      self = this
      xhr = new XMLHttpRequest()
      xhr.open 'GET', '{{ site.url }}/assets/json/posts_date.json', true
      xhr.onload = () ->
        if xhr.readyState == xhr.DONE
          if xhr.status == 200
            data = JSON.parse xhr.response
            for row in self.dates
              for col in row
                if data[col]
                  alert data[col]
      xhr.send null
      return
    setDates: () ->
      start_date = new Date this.start_date
      end_date = new Date this.end_date
      rows = 0
      while start_date.getTime() != end_date.getTime()
        week = []
        for i in [0...7]
          d = new Date start_date
          week[i] = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice -2
          start_date.setDate start_date.getDate() + 1
          if start_date.getTime() == end_date.getTime()
            break
        this.dates[rows] = week
        rows += 1

      return
  mounted: () ->
    this.date_diff = this.getDateDiff()
    this.setDates()
    this.getJSON()
    return
}
