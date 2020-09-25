part of rare_print;

class TextBox extends ControlBase {
  String? text;
  String? binding;
  String? format;

  PrinterTextStyle? style;

  TextBox(this.text, {this.binding, this.format, this.style});

  TextBox.deserialize(XmlElement node) : super.deserialize(node) {
    this.text = node.innerText;
    this.binding = node.getAttribute('binding');
    this.format = node.getAttribute('format');
    style = PrinterTextStyle.deserialize(node);
  }

  
  /// 布局
  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    actualOffset = offset;
    actualSize = size;
    var actualStyle = style!.extendsStyle(canvas.defaultConfig!.fontStyle!);
    if (size!.height!.isInfinite) {
      actualSize = PrinterSize(
          size!.width,
          (canvas.getTextLineHeight(actualStyle) + actualStyle.lineSpace!).toDouble());
    }
    if (actualSize!.width == null) {
      String? displayText = this.getDisplayText(dataSource);
      if (displayText == null) {
        displayText = '';
      }

      actualSize = PrinterSize(
          canvas.getTextWidth(displayText, actualStyle).toDouble(),
          actualSize!.height);
    }
    actualSize = constraints.constrain(actualSize!);
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    builder.text(this.text!);
    style?.serialize(builder);
    if (binding != null) {
      builder.attribute('binding', binding!);
    }
    if (format != null) {
      builder.attribute('format', format!);
    }
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    String? displayText = this.getDisplayText(dataSource);
    if (displayText == null || displayText.isEmpty) {
      return;
    }
    var actualStyle = style!.extendsStyle(canvas.defaultConfig!.fontStyle!);

    var lines = canvas.splitLine(displayText, actualSize!.width!.toInt(),
        actualStyle);

    int lineHeight = canvas.getTextLineHeight(actualStyle);
    int bottom = 0;
    int i = 0;
    while (bottom + lineHeight < actualSize!.height! && i < lines.length) {
      canvas.drawText(
          lines[i],
          offset.translate(actualOffset!.x!, actualOffset!.y! + bottom),
          actualSize!,
          actualStyle);
      i++;
      bottom += lineHeight;
    } 
  }

  String? getDisplayText(DataSourceBase? dataSource) {
    if (binding != null) {
      return dataSource!.execExpressionToString(binding!, format);
    }
    return this.text;
  }

  @override
  String get tagName => 'text';
}
