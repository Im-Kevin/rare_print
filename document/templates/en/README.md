
# Template Demo

``` xml
<page width="837">
  <column>
    <text x="20" y="20">Hello World</text>
  </column>
</page>
```
The root node of each template must be page, there must be a subordinate control under the page, and there can only be one subordinate control

# Unit of Measure-Pixel
The pixel of general small ticket printing is 1mm = 8px, it is recommended to leave a gap when setting the paper size

# Template Control

## Layout Control
- [Page](controls/page.md) -- Not translated
- [Column](controls/column.md) -- Not translated
- [Row](controls/row.md) -- Not translated
- [RowFor](controls/row-for.md) -- Not translated
- [Stack](controls/stack.md) -- Not translated
- [Table](controls/table.md) -- Not translated

## Paint Control
- [Barcode](controls/barcode.md)
- [Line](controls/line.md) -- Not translated
- [Qrcode](controls/qrcode.md) -- Not translated
- [Text](controls/text.md) -- Not translated
- [Image](controls/image.md) -- Not translated

## Directive
- [If](directive/if.md) -- Not translated

# Data

## Default 
Function:
``` dart
now() // Get the current time
fd(number) // Format number
sum(list, filedName) // Total count value, list is the source data, filedName is the total field name, example sum(details,'qty')
toString(value) // Call toString() to convert to a string
```

Global Variable
``` dart
data: Data Source
```

Row Variable
``` dart
data: Data Source
$parent$: Parent Data Source
$rowIndex$ Row Index 0 1 2 ...
```

## Calculated field
The calculated field uses the eval-property node<br/>
Demo
``` xml
<eval-property attch="data.data" propertyName="totalAmount">
  <!-- expression -->
  sum(data.details, 'amount')
</eval-property>
```
Attribute explanation:<br/>
attch: Means attached to a certain path<br/>
propertyName:  Calculated attribute name

## Operator
$$ : Extract the field data of the array completely<br/>
Demo:
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

