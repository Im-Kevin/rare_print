# Text
显示图片的组件
``` xml 
<image>Hello World</image>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [binding] | <code>String</code> |  | 绑定的数据 |