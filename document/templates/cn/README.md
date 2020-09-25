
# 模板例子

``` xml
<page width="837">
  <column>
    <text x="20" y="20">Hello World</text>
  </column>
</page>
```
每一个模板的根节点必须是page, page下面必须有一个下级控件,且只能有一个下级控件

# 计量单位 - 像素
一般的小票打印的像素是1mm = 8px, 在设置纸张大小时候建议留间隙

# 模板控件

## 布局控件
- [Page-页面](controls/page.md)
- [Column-列](controls/column.md)
- [Row-行](controls/row.md)
- [RowFor-行循环](controls/row-for.md)
- [Stack-绝对布局](controls/stack.md)
- [Table-表格](controls/table.md)

## 显示控件
- [Barcode-条形码](controls/barcode.md)
- [Line-线条](controls/line.md)
- [Qrcode-二维码](controls/qrcode.md)
- [Text-文字](controls/text.md)
- [Image-图片](controls/image.md)

## 指令
- [If-条件显示](directive/if.md)

# 数据

## 默认字段
全局方法:
``` dart
now() // 获取当前时间
fd(number) // 格式化数字
sum(list, filedName) // 合计数值,list是源数据, filedName是合计的字段名, 例子 sum(details, 'qty')
toString(value) // 调用toString() 转换成字符串
```

全局变量
``` dart
data: 实际源数据
```

行变量
``` dart
data: 实际源数据
$parent$: 父数据源
$rowIndex$ 行下标 0 1 2 ...
```

## 计算字段
计算字段使用eval-property 节点<br/>
例子
``` xml
<eval-property attch="data.data" propertyName="totalAmount">
  <!-- 表达式 -->
  sum(data.details, 'amount')
</eval-property>
```
属性讲解:<br/>
attch: 表示依附到某个的路径上<br/>
propertyName:  计算属性名

## 操作符
$$ : 将数组的字段数据完全提取出来<br/>
举例:
``` dart
// DataSource
{
  details: [
    {
      name: 'test1'
    },
    {
      name: 'test2'
    },
    {
      name: 'test3'
    },
    {
      name: 'test4'
    }
  ]
}

data.details.name -> 'test1'

data.details.$$name -> ['test1', 'test2', 'test3', 'test4']
```

