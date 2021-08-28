
[中文移步这里](README.CN.md)

Some documents are not translated into English, welcome to submit RP

# RarePrint [![pub package](https://img.shields.io/pub/v/rare_print.svg)](https://pub.dartlang.org/packages/rare_print)
This is a rendering library for printing.<br/> 
Support preview, use pure instruction printing, avoid the problem of excessive instruction caused by picture printing
 
    Currently supported instruction set:
        CPCL
        TSCL

[Document](document/templates/en/README.md)

# Print Demo
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

    io.send(canvas.toCommand()); // output instruction
```

# Preview Demo
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

