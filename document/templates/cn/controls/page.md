# Page
一个模板的根节点,可用于配置一些基本信息
``` xml 
<page width="837">
<!-- eval-property -->
<!-- printer-config -->
<!-- control -->
</page>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| width | <code>int</code> | 0 | 宽度 必填 |
| [height] | <code>int</code> | 0 | 高度,一般不需要设置 |

## FontType 注册字体
``` xml
<page width="837">
<!-- eval-property -->
<font-type
    fontType = "value"
    fontBaseWidth = "value"
    fontBaseHeight = "value"
    >
</font-type>
<!-- control -->
</page>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| fontType | <code>int</code> |  | 字体类型 |
| fontBaseWidth | <code>int</code> |  | 字体大小1的时候的宽度
| fontBaseHeight | <code>int</code> |  | 字体大小1的时候的高度


## PrinterConfig 设置全局样式
``` xml
<page width="837">
<!-- eval-property -->
<printer-config
    align = "value"
    fontType = "value"
    fontSize = "value"
    fontBlod = "value"
    underline = "value"
    lineSpace = "value"
    lineHeight = "value"
    >
</printer-config>
<!-- control -->
</page>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [align] | <code>start,center,end</code> | start | 文字位置 |
| [fontType] | <code>int</code> | 1 | 字体类型 |
| [fontSize] | <code>int</code> | 1 | 字体大小 |
| [fontBlod] | <code>bool</code> | false | 是否粗体 |
| [underline] | <code>bool</code> | false | 是否删除线 |
| [lineSpace] | <code>int</code> | 4| 行距 |
| [lineHeight] | <code>double</code> | 1.2 | 行高 |

## PageInfo 设置纸张格式
``` xml
<page width="837">
<!-- eval-property -->
<printer-config>
    <page-info
        gapmMM="0"
        gapnMM="0"
        pageCount=""1
    ></page-info>
</printer-config>
<!-- control -->
</page>
```

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [gapmMM] | <code>int</code> | 1 | 间隙M (TSC)(单位MM) |
| [gapnMM] | <code>int</code> | 1 | 间隙N (TSC)(单位MM) |
| [pageCount] | <code>int</code> | 1 | 重复打印次数(TSC) |