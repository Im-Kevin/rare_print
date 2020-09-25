# Row
按顺序排列组件, 子组件的x属性代表相对上一个子组件的位置
``` xml 
<row>
<!-- control -->
</row>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [width] | <code>int</code> | 0 | 宽度 |
| [height] | <code>int</code> | 0 | 高度 |
| [wordWrap] | <code>bool</code> | false | 自动换行 |
| [align] | <code>start,center,end</code> | start | 排列顺序 |