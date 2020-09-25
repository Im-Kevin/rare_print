part of rare_print;

class LineBox extends ControlBase {

  LineBox();

  LineBox.deserialize(XmlElement node):super.deserialize(node);

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    canvas.drawLine(offset + actualOffset!, size!);
  }

  @override
  String get tagName => 'line';

}