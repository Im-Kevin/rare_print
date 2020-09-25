# Text
显示文字的组件
``` xml 
<text width="100">Hello World</text>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [width] | <code>int | auto</code> | 0 | 宽度 |
| [height] | <code>int</code> | 0 | 高度 |
| [binding] | <code>String</code> |  | 绑定的数据 |
| [format] | <code>String</code> |  | 格式化,需和binding一起使用 |
| [align] | <code>start,center,end</code> | start | 文字位置 |
| [fontType] | <code>int</code> | 1 | 字体类型 |
| [fontSize] | <code>int</code> | 1 | 字体大小 |
| [fontBlod] | <code>bool</code> | false | 是否粗体 |
| [underline] | <code>bool</code> | false | 是否删除线 |
| [lineSpace] | <code>int</code> | 4| 行距 |
| [lineHeight] | <code>double</code> | 1.2 | 行高 |