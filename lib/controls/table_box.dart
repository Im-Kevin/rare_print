part of rare_print;

class TableBox extends MultiControlBase<TableColumn> {
  String binding;

  TableBoxBorder border;

  List<TableCellData> cells = [];

  String? condition;

  int _rowCount = 0;

  TableBox.deserialize(XmlElement node) : 
    binding = node.getAttribute('binding')!,
    border = TableBoxBorder.deserialize(node),
    super.deserialize(node) {
    assert(this.size == null || !this.size!.height!.isInfinite, 'height 必须指定');
    condition = node.getAttribute('if');
  }

  serialize(XmlBuilder builder) {
    super.serialize(builder);
    builder.attribute('binding', binding);
    border.serialize(builder);
  }

  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    assert(constraints.maxHeight.isInfinite, '高度必须是浮动的');
    cells.clear();

    Map<int, TableCellData> mergeColumnMap = <int, TableCellData>{};

    List data = this.dataSource!.execExpressionToValue(binding);
    _rowCount = data.length;

    double bottom = 0;

    double rowHeight = this.size!.height ?? 0;
    for (int y = 0; y < data.length; y++) {
      final rowData = data[y];

      var rowDataSource = RowDataSource(rowData, this.dataSource!, y);
      if (condition != null && condition != '') {
        var value = rowDataSource.execExpressionToValue(condition!);
        if (value != true) {
          continue;
        }
      }
      double offsetX = 0;
      for (int x = 0; x < children.length; x++) {
        final child = children[x];
        if (child.columnMerge == true) {
          var mergeText = child.getDisplayText(rowDataSource);
          if (mergeColumnMap.containsKey(x) &&
              mergeColumnMap[x]!.mergeText == mergeText) {
            mergeColumnMap[x]!.mergeRow++;
            mergeColumnMap[x]!.size = PrinterSize(mergeColumnMap[x]!.size!.width,
                mergeColumnMap[x]!.size!.height! + rowHeight);
          } else {
            var cell = TableCellData();
            cell.rowData = rowDataSource;
            cell.column = child;
            cell.mergeRow = 1;
            cell.mergeText = mergeText;
            cell.rowIndex = y;
            cell.columnIndex = x;
            cell.offset = PrinterOffset(offsetX, bottom);
            cell.size = PrinterSize(child.size!.width, rowHeight);
            mergeColumnMap[x] = cell;
            cells.add(cell);
          }
        } else {
          var cell = TableCellData();
          cell.rowData = rowDataSource;
          cell.column = child;
          cell.mergeRow = 1;
          cell.rowIndex = y;
          cell.columnIndex = x;
          cell.offset = PrinterOffset(offsetX, bottom);
          cell.size = PrinterSize(child.size!.width, rowHeight);
          cells.add(cell);
        }
        offsetX += child.size!.width!;
      }

      bottom += rowHeight;
    }

    double rowWidth = 0;

    for (var child in this.children) {
      rowWidth += child.size!.width!;
    }

    actualOffset = this.offset;
    actualSize = PrinterSize(rowWidth, bottom);
  }

  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    for (var cellItem in cells) {
      cellItem.paint(canvas, offset + this.actualOffset!);
    }
    border.paint(canvas, actualOffset!, actualSize!, _rowCount,
        this.children.length, cells);
  }

  @override
  String get tagName => 'table';
}

class TableBoxBorder {
  TableBoxBorder.deserialize(XmlElement node) {
    top = int.tryParse(node.getAttribute('borderTop') ?? '');
    right = int.tryParse(node.getAttribute('borderRight') ?? '');
    bottom = int.tryParse(node.getAttribute('borderBottom') ?? '');
    left = int.tryParse(node.getAttribute('borderLeft') ?? '');
    horizontalInside =
        int.tryParse(node.getAttribute('borderHorizontalInside') ?? '');
    verticalInside =
        int.tryParse(node.getAttribute('borderVerticalInside') ?? '');
  }

  serialize(XmlBuilder builder) {
    if (top != null) {
      builder.attribute('borderTop', top!);
    }
    if (right != null) {
      builder.attribute('borderRight', right!);
    }
    if (bottom != null) {
      builder.attribute('borderBottom', bottom!);
    }
    if (left != null) {
      builder.attribute('borderLeft', left!);
    }
    if (horizontalInside != null) {
      builder.attribute('borderHorizontalInside', horizontalInside!);
    }
    if (verticalInside != null) {
      builder.attribute('borderVerticalInside', verticalInside!);
    }
  }

  /// The top side of this border.
  int? top;

  /// The right side of this border.
  int? right;

  /// The bottom side of this border.
  int? bottom;

  /// The left side of this border.
  int? left;

  /// The horizontal interior sides of this border.
  int? horizontalInside;

  /// The vertical interior sides of this border.
  int? verticalInside;

  void paint(PrinterCanvas canvas, PrinterOffset offset, PrinterSize size, int rowCount,
      int columnCount, List<TableCellData> cells) {
    for (var i = 0; i < cells.length; i++) {
      final cell = cells[i];
      if (horizontalInside != null) {
        if (cell.rowIndex! < rowCount - 1) {
          var x = cell.offset!.x;
          var y = cell.offset!.y! + cell.size!.height!;
          canvas.drawLine(offset.translate(x!, y),
              PrinterSize(cell.size!.width, horizontalInside!.toDouble()));
        }
      }
      if (verticalInside != null) {
        if (cell.columnIndex! < columnCount - 1) {
          var x = cell.offset!.x! + cell.size!.width!;
          var y = cell.offset!.y;
          canvas.drawLine(offset.translate(x, y!),
              PrinterSize(verticalInside!.toDouble(), cell.size!.height));
        }
      }
    }

    if (top != null) {
      canvas.drawLine(offset, PrinterSize(size.width, top!.toDouble()));
    }

    if (left != null) {
      canvas.drawLine(offset, PrinterSize(left!.toDouble(), size.width));
    }

    if (bottom != null) {
      canvas.drawLine(offset.translate(0, size.height!),
          PrinterSize(size.width, bottom!.toDouble()));
    }

    if (right != null) {
      canvas.drawLine(
          offset.translate(size.width!, 0), PrinterSize(right!.toDouble(), size.height));
      canvas.drawLine(offset, PrinterSize(size.width, top!.toDouble()));
    }
  }
}

class TableColumn extends TextBox {
  bool columnMerge = false;

  TableColumn(String text) : super(text);

  TableColumn.deserialize(XmlElement node) : 
    columnMerge = stringToBool(node.getAttribute('columnMerge')) ?? false,
    super.deserialize(node) {
    assert(this.size == null || !this.size!.width!.isInfinite, 'width 必须指定');
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    builder.attribute('columnMerge', columnMerge);
  }

  @override
  String get tagName => 'table-column';
}

class TableCellData {
  /// Row Data
  DataSourceBase? rowData;

  TableColumn? column;

  String? mergeText;

  int mergeRow = 1;

  PrinterOffset? offset;

  PrinterSize? size;

  int? rowIndex;

  int? columnIndex;

  paint(PrinterCanvas canvas, PrinterOffset offset) {
    column!.setDataSource(this.rowData!);
    column!.actualOffset = this.offset;
    column!.actualSize = this.size;
    column!.paint(canvas, offset);
  }
}
