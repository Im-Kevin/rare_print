[English](README.md)

# RarePrint
这是一个用于专门打印的渲染库, 不对接具体硬件<br/> 
支持预览功能,使用纯指令打印,避免了图片打印导致指令集过大的问题
 
    目前支持打印语言:
        CPCL
        TSCL

[Document](document/templates/cn/README.md)

# 打印例子
``` dart
    final demoXml = '<page width="880">...</page>'
    var control = ControlBase.create(demoXml);

    var jsonData = json.decode(dataSource);

    control.setDataSource(DataSource(jsonData));

    control.performLayout(PrinterConstraints(maxWidth: 837));
    CPCLCanvas canvas = CPCLCanvas();
    canvas.pageSize = control.actualSize;
    canvas.reset();

    control.paint(canvas, PrinterOffset.zero);

    canvas.end();

    io.send(canvas.toCommand); // 输出具体指令
```

# 预览例子
``` dart
    ControlBase control;
    @override
    void initState() {
        super.initState();
        final demoXml = '<page width="880">...</page>'
        control = ControlBase.create(demoXml);
    }

    @override
    Widget build(BuildContext context) {
        return PreviewWidget(
            control: control
        );
    }

```

