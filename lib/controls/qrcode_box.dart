part of rare_print;

class QRCodeBox extends ControlBase {
  String? content;
  String? binding;
  String? format;
  bool imagePaint;

  ECCLevelEnum ecc = ECCLevelEnum.M;

  QRCodeBox(this.content, {this.binding, this.format, this.imagePaint = false});

  QRCodeBox.deserialize(XmlElement node):
    this.imagePaint = stringToBool(node.getAttribute('imagePaint')) ?? false,
    super.deserialize(node) {
    this.content = node.innerText.trim();
    this.binding = node.getAttribute('binding');
    this.format = node.getAttribute('format');
    this.ecc = stringToECC(node.getAttribute('ecc') ?? '');
    
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    builder.text(content!);
    if(binding != null) {
      builder.attribute('binding', binding!);
    }
    if (format != null) {
      builder.attribute('format', format!);
    }
    builder.attribute('ecc', eccToString(this.ecc));
  }



  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    var value = this.getValue(dataSource);
    if (value == null) {
      return;
    }
    if (imagePaint) {
      canvas.drawQRCodeBitmap(value, offset + this.actualOffset!, actualSize!, ecc);
    } else {
      canvas.drawQRCode(value, offset + this.actualOffset!, actualSize!, ecc);
    }
  }

  String? getValue(DataSourceBase? dataSource) {
    if (binding != null) {
      return dataSource!.execExpressionToString(binding!, format);
    }
    return this.content;
  }
  
  @override
  String get tagName => 'qrcode';
}
