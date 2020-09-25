part of rare_print;

class IfBox extends ControlBase {
  String? condition;
  ControlBase? child;
  
  IfBox.deserialize(XmlElement node) : super.deserialize(node) {
    condition = node.getAttribute('if');
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    var value = this.dataSource!.execExpressionToValue(condition!);
    if (value == true) {
      child!.paint(canvas, actualOffset! + offset);
    } 
  }


  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    var value = this.dataSource!.execExpressionToValue(condition!);
    actualOffset = PrinterOffset.zero;

    if (value == true) {
      child!.performLayout(constraints, canvas);
      
      actualSize = PrinterSize(child!.actualSize!.width! + child!.actualOffset!.x!, child!.actualSize!.height! + child!.actualOffset!.y!);
    } else {
      actualSize = PrinterSize.zero;
    }
  }

  
  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    if (condition != null) {
      builder.attribute('if', condition!);
    }
  }

  @override
  String get tagName => 'if';

  @override
  setDataSource(DataSourceBase dataSource) {
    super.setDataSource(dataSource);
    this.child!.setDataSource(dataSource);
  }
}