part of rare_print;

class ImageBox extends ControlBase {
  String? binding;

  ImageBox(this.binding);

  ImageBox.deserialize(XmlElement node):super.deserialize(node){
    this.binding = node.getAttribute('binding');
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
  }

  /// 布局
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    super.performLayout(constraints, canvas);
    List<List<bool>>? image = this.getValue(dataSource);
    if (image != null && image.length > 0) {
      double imageWidth = image[0].length.toDouble();
      actualSize = PrinterSize(imageWidth, image.length.toDouble());
    }
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) async {
    List<List<bool>>? image = this.getValue(dataSource);
    if (image != null && image.length > 0) {
      canvas.drawBitmap(actualOffset!, actualSize!, image);
    }
  }

  @override
  String get tagName => 'image';


  List<List<bool>>? getValue(DataSourceBase? dataSource) {
    if (binding != null) {
      return dataSource!.execExpressionToValue(binding!);
    }
    return null;
  }
}