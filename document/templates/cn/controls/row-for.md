# RowFor
从左到右排列组件, 子组件的x属性代表相对上一个子组件的位置, 带有循环数组的功能,适用于多行渲染, y属性代表当前数据行的相对位置
``` json
    {
        "listData": [
            {
                "test": "test1"
            },
            {
                "test": "test2"
            }
        ],
        "parentTitle": "title"
    }
```
``` xml 
<row-for binding="data.listData">
    <text binding="data.$rowIndex$ + 1"></text>
    <text binding="data.$parent$.parentTitle"></text>
    <text binding="data.test"></text>
</row-for>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [x] | <code>int</code> | 0 | 相对位置X轴<br/>父组件为Stack、Page、Column时代表相对父组件的位置<br/>Row、RowFor代表相对上一个组件的位置<br/>Table无效 |
| [y] | <code>int</code> | 0 | 相对位置y轴<br/>父组件为Stack、Page、Row时代表相对父组件的位置<br/>RowFor代表当前行的相对位置<br/>Column代表相对上一个组件的位置<br/>Table无效  |
| [width] | <code>int</code> | 0 | 宽度 |
| [height] | <code>int</code> | 0 | 高度 |
| binding | <code>List</code> |  | 绑定的数据, 必填 |