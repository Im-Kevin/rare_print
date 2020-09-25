
[中文移步这里](README.CN.md)

Some documents are not translated into English, welcome to submit RP

# RarePrint
This is a rendering library for printing.<br/> 
Support preview, use pure instruction printing, avoid the problem of excessive instruction caused by picture printing
 
    Currently supported instruction set:
        CPCL
        TSCL

[Document](document/templates/en/README.md)

# Print Demo
``` dart
    final demoXml = '<page width="880">...</page>'
    var control = ControlBase.createForXml(demoXml);

    var jsonData = json.decode(dataSource);

    control.setDataSource(DataSource(jsonData));

    control.performLayout(BoxConstraints(maxWidth: 837));
    CPCLCanvas canvas = CPCLCanvas();
    canvas.pageSize = control.actualSize;
    canvas.reset();

    control.paint(canvas, Offset.zero);

    canvas.end();

    io.send(canvas.buffer); // canvas.buffer is instruction
```

# Preview Demo
``` dart
    ControlBase control;
    @override
    void initState() {
        super.initState();
        final demoXml = '<page width="880">...</page>'
        control = ControlBase.createForXml(demoXml);
    }

    @override
    Widget build(BuildContext context) {
        return PreviewWidget(
            control: control
        );
    }

```

