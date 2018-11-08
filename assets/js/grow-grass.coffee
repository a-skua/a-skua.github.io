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
            }]"></div>
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
    first_col_end: 4
    date_diff: 0
    dates: [[]]
    style:
      wrapper:
        display: 'grid'
        gridGap: '2px'
        gridAutoColumns: 'minmax(1em, 1em)'
        gridAutoRows: 'minmax(1em, 1em)'
      item:
        backgroundColor: 'green'
      week:
        fontSize: '1em'
        textAlign: 'right'
  methods:
    getGridColumn: (num) ->
      (num - 1) / this.rows_num + this.first_col_end - 1
    getGridRow: (num) ->
      position = num % this.rows_num
      if position == 0 then 7 else position
    getDateDiff: () ->
      start_date = this.getStartDate()
      end_date = this.getEndDate()
      date_diff = (end_date - start_date) / 24 / 60 / 60 / 1000
      date_diff
    getStartDate: () ->
      date = new Date()
      date.setFullYear date.getFullYear() - 1
      date.setMonth if date.getMonth() == 11 then 0 else date.getMonth() + 1
      date.setDate 1
      date.setDate date.getDate() - date.getDay()
      date.setHours 0
      date.setMinutes 0
      date.setMilliseconds 0
      date
    getEndDate: () ->
      date = new Date()
      date.setDate date.getDate() + 1
      date.setHours 0
      date.setMinutes 0
      date.setMilliseconds 0
      date
    setDates: () ->
      return
  mounted: () ->
    this.date_diff = this.getDateDiff()
    this.
    return
}
