part of rare_print;

class RowBox extends MultiControlBase {
  bool wordWrap;
  AlignEnum align;
  double minWidth;

  RowBox({this.wordWrap = false, this.align = AlignEnum.start, this.minWidth = 0}): super();

  RowBox.deserialize(XmlElement node) : 
    this.wordWrap = stringToBool(node.getAttribute('wordWrap')) ?? false,
    this.align = stringToAlign(node.getAttribute('align')) ?? AlignEnum.start,
    this.minWidth = double.tryParse(node.getAttribute('minWidth') ?? '')  ?? 0,
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
    double maxWidth = 0;
    double width = 0;
    double height = 0; // 当前行高
    double top = 0;
    List<ControlBase> currentRow = [];
    List<List<ControlBase>> rows = [currentRow];
    for (var child in children) { // 计算大小并且设置Top偏移
      if (child.isRender) {
        if (this.wordWrap) {
          child.performLayout(PrinterConstraints(maxHeight: childConstraints.maxHeight, maxWidth: childConstraints.maxWidth), canvas);
          width += child.actualOffset!.x! + child.actualSize!.width!; // 计算当前行宽
          if (childConstraints.maxWidth < width) { // 超出换行
            top += height;
            height = child.actualSize!.height! + child.actualOffset!.y!;
            width = child.actualOffset!.x! + child.actualSize!.width!;
            currentRow = [];
            rows.add(currentRow);
          } else {
            height = Math.max(child.actualSize!.height! + child.actualOffset!.y!, height); // 计算当前行最高
          }
          currentRow.add(child);
          child.actualOffset = child.actualOffset!.translate(0, top); // 设置偏移
          maxWidth = Math.max(maxWidth, width); // 计算总高度
        } else {
          child.performLayout(PrinterConstraints(maxHeight: childConstraints.maxHeight, maxWidth: childConstraints.maxWidth - maxWidth), canvas);
          maxWidth += child.actualOffset!.x! + child.actualSize!.width!;
          height = Math.max(child.actualSize!.height! + child.actualOffset!.y!, height);
          currentRow.add(child);
        }
      }
    }
    

    if (this.align != AlignEnum.start) {
      maxWidth = childConstraints.maxWidth;
    }
    
    maxWidth = Math.max(maxWidth, minWidth);

    for (var row in rows) {
      _calcRowOffset(row, maxWidth);
    }

    if (size?.width != null && size!.width!.isInfinite) {
      width = maxWidth;
    } else {
      width = size!.width!;
    }
    if (size?.height != null && size!.height!.isInfinite) {
      height = top + height;
    }else {
      height = size!.height!;
    }
    actualSize = PrinterSize(width, height);
  }


  @override
  String get tagName => 'row';

  _calcRowOffset(List<ControlBase> row, double maxWidth) {
    if (align == AlignEnum.start) {
      double currentX = 0;
      for (var child in row) {
        child.actualOffset = child.actualOffset!.translate(currentX, 0);
        currentX = child.actualOffset!.x! + child.actualSize!.width!;
      }
      return;
    }

    if (align == AlignEnum.center) {
      double currentRowWidth = 0;
      for (var child in row) { // 计算行宽
        currentRowWidth += child.actualOffset!.x! + child.actualSize!.width!;
      }
      double currentX = (maxWidth - currentRowWidth) / 2;
      for (var child in row) {
        child.actualOffset = child.actualOffset!.translate(currentX, 0);
        currentX = child.actualOffset!.x! + child.actualSize!.width!;
      }
      return;
    }

    if (align == AlignEnum.end) {
      double currentX = maxWidth;
      for (var child in row) {
        currentX = currentX - child.actualSize!.width! -  child.actualOffset!.x!;
        child.actualOffset = PrinterOffset(currentX, child.actualOffset!.y!);
      }
    }
  }
}