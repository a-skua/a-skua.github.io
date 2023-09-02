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
      <p v-if="count === 0">No articles</p>
      <p v-else-if="count === 1">$ count $ article</p>
      <p v-else>$ count $ articles</p>
      <div :style="style.wrapper">
        <template v-for="(v, k, i) in dates">
          <div
            :style="[bgColor(v.articles.length), style.column, {
              gridColumn: getGridColumn(i),
              gridRow: getGridRow(i)
            }]"
            @click="onClickColumn(k, v, $event)">
          </div>
          <div
            v-if="v.month"
            :style="{
              gridColumn: getGridColumn(i - 7),
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
            $ weeks[i] $
          </div>
        </template>
      </div>

      <div>
        <p>$ info.date $</p>
        <ul>
          <li v-for="article in info.articles"><a :href="article.url">$ article.title $</a></li>
        </ul>
      </div>
    </div>
  '''
  data:
    info:
      date: ''
      articles: []
    count: 0
    rows_num: 8
    first_row_end: 2
    first_col_end: 4
    date_diff: 0
    start_date: ''
    end_date: ''
    dates: {}
    posts: {}
    weeks: [
      '{{ site.data.grow-grass.week.sun }}'
      '{{ site.data.grow-grass.week.mon }}'
      '{{ site.data.grow-grass.week.tue }}'
      '{{ site.data.grow-grass.week.wed }}'
      '{{ site.data.grow-grass.week.thu }}'
      '{{ site.data.grow-grass.week.fri }}'
      '{{ site.data.grow-grass.week.sat }}'
    ]
    style:
      wrapper:
        display: 'grid'
        gridGap: '2px'
        gridAutoColumns: 'minmax(1em, 1em)'
        gridAutoRows: 'minmax(1em, 1em)'
        overflow: 'auto'
      column:
        cursor: 'pointer'
      item:
        less:
          backgroundColor: '{{ site.data.grow-grass.less }}'
        one:
          backgroundColor: '{{ site.data.grow-grass.one }}'
        two:
          backgroundColor: '{{ site.data.grow-grass.two }}'
        more:
          backgroundColor: '{{ site.data.grow-grass.more }}'
      week:
        fontSize: '1em'
        textAlign: 'right'
  methods:
    onClickColumn: (date, values, event) ->
      this.info.date = date
      this.info.articles = values.articles
      return
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
      switch num % 12
        when 0
          '{{ site.data.grow-grass.month.jan }}'
        when 1
          '{{ site.data.grow-grass.month.feb }}'
        when 2
          '{{ site.data.grow-grass.month.mar }}'
        when 3
          '{{ site.data.grow-grass.month.apr }}'
        when 4
          '{{ site.data.grow-grass.month.may }}'
        when 5
          '{{ site.data.grow-grass.month.jun }}'
        when 6
          '{{ site.data.grow-grass.month.jul }}'
        when 7
          '{{ site.data.grow-grass.month.aug }}'
        when 8
          '{{ site.data.grow-grass.month.sep }}'
        when 9
          '{{ site.data.grow-grass.month.oct }}'
        when 10
          '{{ site.data.grow-grass.month.nov }}'
        when 11
          '{{ site.data.grow-grass.month.dec }}'
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
                self.dates[key].articles = data[key]
                self.count += data[key].length
      xhr.send null
      return
    setDates: () ->
      start_date = new Date this.start_date
      end_date = new Date this.end_date
      dates = {}
      month = null
      isMonth = true
      while start_date.getTime() != end_date.getTime()
        d = new Date start_date
        ymd = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice -2

        if d.getDate() > 7 && d.getDate() <= 14 && isMonth
          month = this.getMonth start_date.getMonth()
          isMonth = false
        else
          month = null

        dates[ymd] = {
          articles: []
          month: month
        }

        start_date.setDate start_date.getDate() + 1
        if d.getMonth() != start_date.getMonth()
          isMonth = true

      this.dates = dates
      return
  mounted: () ->
    this.date_diff = this.getDateDiff()
    this.setDates()
    this.getJSON()
    return
}
