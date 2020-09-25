part of rare_print;

class ColumnBox extends MultiControlBase {
  double minHeight;

  ColumnBox({this.minHeight = 0});

  ColumnBox.deserialize(XmlElement node) : 
      minHeight = double.tryParse(node.getAttribute('minHeight') ?? '')  ?? 0,
      super.deserialize(node);

  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    PrinterConstraints childConstraints;
    actualSize = null;
    actualOffset = offset;
    if (size != null) {
      childConstraints = PrinterConstraints.constraints(constraints, size!);
    } else {
      childConstraints = constraints;
    }

    double width = 0;
    double height = 0;
    for (var child in children) {
      if (child.isRender) {
        child.performLayout(PrinterConstraints(maxHeight: childConstraints.maxHeight - height, maxWidth: childConstraints.maxWidth), canvas);
        child.actualOffset = child.actualOffset!.translate(0, height);
        width = Math.max(child.actualSize!.width! + child.actualOffset!.x!, width);
        height = child.actualSize!.height! + child.actualOffset!.y!;
      }
    }
    height = Math.max(this.minHeight, height);
    if (size?.width != null && !size!.width!.isInfinite) {
      width = size!.width!;
    }
    if (size?.height != null && !size!.height!.isInfinite) {
      height = size!.height!;
    }
    actualSize = PrinterSize(width, height);
  }


  @override
  String get tagName => 'column';

}