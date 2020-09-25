part of rare_print;

class BarcodeBox extends ControlBase {
  String? content;
  String? binding;
  String? format;
  
  int lineWidth = 1;
  bool showText = false;

  BarcodeBox(this.content, {this.binding, this.format,this.lineWidth = 1, this.showText = false});  

  BarcodeBox.deserialize(XmlElement node) : 
    this.content = node.innerText.trim(),
    super.deserialize(node) {
    assert(this.size == null || !this.size!.height!.isInfinite, 'height 必须指定');
    this.binding = node.getAttribute('binding');
    this.format = node.getAttribute('format');
    this.lineWidth = int.tryParse(node.getAttribute('lineWidth') ?? '') ?? 1;
    this.showText = stringToBool(node.getAttribute('showText')) ?? false;
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    if (content != null) {
      builder.text(content!);
    }
    if (binding != null) {
      builder.attribute('binding', binding!);
    }
    if (format != null) {
      builder.attribute('format', format!);
    }
    builder.attribute('lineWidth', lineWidth);
    builder.attribute('showText', showText);
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    var value = getValue(this.dataSource);
    if (value == null) {
      return;
    }
    if (showText) {
      int textHeight = canvas.getTextLineHeight(canvas.config!.fontStyle!);

      var barcodeHeight = actualSize!.height! - textHeight;
      canvas.drawBarCodeForSize(value, offset + actualOffset!,
          PrinterSize(actualSize!.width, barcodeHeight), lineWidth);

      canvas.drawText(
          value,
          offset + actualOffset!.translate(0, barcodeHeight),
          PrinterSize(actualSize!.width, textHeight.toDouble()),
          canvas.config!.fontStyle!.copyWith(align: AlignEnum.center));
    } else {
      canvas.drawBarCodeForSize(content, actualOffset!, actualSize!);
    }
  }

  String? getValue(DataSourceBase? dataSource) {
    if (binding != null) {
      return dataSource!.execExpressionToString(binding!, format);
    }
    return this.content;
  }

  @override
  String get tagName => 'barcode';
}
