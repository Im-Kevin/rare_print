# Table
表格组件, 支持纵向合并, 边框线 子组件的x和y无效 子组件只支持table-column
``` json
    {
        "listData": [
            {
                "column1": "test1",
                "column2": "row1"
            },
            {
                "column1": "test1",
                "column2": "row2"
            },
            {
                "column1": "test2",
                "column2": "row3"
            }
        ],
        "parentTitle": "title"
    }
```
``` xml 
<table binding="data.listData">
    <table-column columnMerge="true" binding="data.$rowIndex$ + 1"></table-column>
    <table-column binding="data.$parent$.parentTitle"></table-column>
    <table-column binding="data.test"></table-column>
</table>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [width] | <code>int</code> | 0 | 宽度 |
| height | <code>int</code> |  | 高度 必填 |
| [borderTop] | <code>int</code> | 0 | 外边框上 |
| [borderRight] | <code>int</code> | 0 | 外边框右 |
| [borderBottom] | <code>int</code> | 0 | 外边框下 |
| [borderLeft] | <code>int</code> | 0 | 外边框左 |
| [borderHorizontalInside] | <code>int</code> | 0 | 内边框横向 |
| [borderVerticalInside] | <code>int</code> | 0 | 内边框纵向 |
| binding | <code>List</code> |  | 绑定的数据, 必填 |

# TableColumn
Table的列
``` xml 
<table-column width="100">Hello World</table-column>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| columnMerge | <code>bool</code> | false | 是否合并 |
| width | <code>int</code> |  | 宽度,必填 |
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