# barcode
显示二维码的组件
``` xml 
<qrcode width="170" height="170">testCode</qrcode>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [width] | <code>int</code> | 0 | 宽度 |
| [height] | <code>int</code> |  | 高度 |
| [binding] | <code>String</code> |  | 绑定的数据 |
| [format] | <code>String</code> |  | 格式化,需和binding一起使用 |
| [ecc] | <code>L,M,Q,H</code> | M | 纠错等级 |
| [imagePaint] | <code>bool</code> | false | 使用图片模式打印 |