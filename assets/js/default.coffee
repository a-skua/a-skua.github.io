---
---
samurai_banner = new Vue {
  delimiters: [
    '$'
    '$'
  ]
  el: '#samurai-banner'
  template: '''
    <div>
      <p>$ text.tag $</p>
      <p>$ addDate(today(), 'D', 7) + text.main $</p>
    </div>
  '''
  data:
    week: [
      '日'
      '月'
      '火'
      '水'
      '木'
      '金'
      '土'
    ]
    text:
      tag: 'samurai banner'
      main: 'までに(ry'
  methods:
    addDate: (d, t, n) ->
      switch t
        when 'Y'
          d.setFullYear d.getFullYear() + n
        when 'M'
          d.setMonth d.getMonth() + n
        when 'D'
          d.setDate d.getDate() + n
      (d.getMonth() + 1) + '/' + d.getDate() + '(' + this.week[d.getDay()] + ')'
    today: () ->
      new Date()
}
