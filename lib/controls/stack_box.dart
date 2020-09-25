part of rare_print;

class StackBox extends MultiControlBase {
  StackBox();

  StackBox.deserialize(XmlElement node) : super.deserialize(node);

  
  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    super.performLayout(constraints, canvas);
    for (var child in children) {
      if (child.isRender) {
        child.performLayout(constraints, canvas);
      }
    }
  }

  @override
  String get tagName => 'stack';

}