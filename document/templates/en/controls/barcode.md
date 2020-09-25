# Barcode
BarCode Control
``` xml 
<barcode width="100" height="50">12345</barcode>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | Relative position X axis<br/>When the parent component is Stack, Page, or Column, it represents the position relative to the parent component<br/>Row, RowFor represent the position relative to the previous component<br/>Table is invalid |
| [y] | <code>int</code> | 0 | Relative position Y axis<br/>When the parent component is Stack, Page, Row, it represents the position relative to the parent component<br/>RowFor represents the relative position of the current row<br/>Column represents the position relative to the previous component<br/>Table is invalid  |
| [width] | <code>int</code> | 0 | Width |
| height | <code>int</code> |  | Height, Required |
| [binding] | <code>String</code> |  | Binding expression |
| [format] | <code>String</code> |  | Format expression, Need to be used with binding |
| [lineWidth] | <code>int</code> | 1 | The width of a single line |
| [showText] | <code>bool</code> | false | Whether to display text |