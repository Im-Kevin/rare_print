part of rare_print;

class RowFor extends MultiControlBase {
  String binding;
  String? condition;

  RowFor.deserialize(XmlElement node) : 
    binding = node.getAttribute('binding')!,
    condition = node.getAttribute('if'),
    super.deserialize(node);

  PrinterConstraints? _constraints;

  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    assert(constraints.maxHeight.isInfinite, '高度必须是浮动的');

    _constraints = constraints;

    double height = 0;
    List? data = this.dataSource!.execExpressionToValue(binding);
    if (data == null) {
      return;
    }
    if (size!.height!.isFinite) {
      height = data.length * size!.height!;
    } else {
      for (int y = 0; y < data.length; y++) {
        final rowData = data[y];

        var rowDataSource = RowDataSource(rowData, this.dataSource!, y);
        if (condition != null && condition != '') {
          var value = rowDataSource.execExpressionToValue(condition!);
          if (value != true) {
            continue;
          }
        }
        double rowHeight = 0;
        for (var child in children) {
          if (child.isRender) {
              child.setDataSource(rowDataSource);
              child.performLayout(constraints, canvas);
              rowHeight = Math.max(
                  child.actualOffset!.y! + child.actualSize!.height!, rowHeight);
          }
        }

        height += rowHeight;
      }
    }
    actualSize =
        PrinterSize(size!.width!.isInfinite ? constraints.maxWidth : size!.width, height);
    actualOffset = offset;
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    List? data = this.dataSource!.execExpressionToValue(binding);
    if (data == null) {
      return;
    }
    double height = 0;

    for (int y = 0; y < data.length; y++) {
      final rowData = data[y];

      var rowDataSource = RowDataSource(rowData, this.dataSource!, y);

      if (condition != null && condition != '') {
        var value = rowDataSource.execExpressionToValue(condition!);
        if (value != true) {
          continue;
        }
      }
      double rowHeight = 0;
      for (var child in children) {
        if (child.isRender) {
          child.setDataSource(rowDataSource);
          child.performLayout(_constraints!, canvas);
          child.paint(canvas,
              offset.translate(actualOffset!.x! + 0, actualOffset!.y! + height));
          rowHeight = Math.max(child.actualOffset!.y! + child.actualSize!.height!, rowHeight);
        }
      }
      if (size!.height!.isFinite) {
        height += size!.height!;
      } else {
        height += rowHeight;
      }
    }
  }

  @override
  String get tagName => 'row-for';
}
