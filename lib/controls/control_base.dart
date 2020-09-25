part of rare_print;

abstract class ControlBase {
  static ControlBase create(XmlElement node) {
    final String type = node.name.local;
    ControlBase? result;
    switch (type) {
      case 'line':
        result = LineBox.deserialize(node);
        break;
      case 'text':
        result = TextBox.deserialize(node);
        break;
      case 'column':
        result = ColumnBox.deserialize(node);
        break;
      case 'row':
        result = RowBox.deserialize(node);
        break;
      case 'stack':
        result = StackBox.deserialize(node);
        break;
      case 'table':
        result = TableBox.deserialize(node);
        break;
      case 'table-column':
        result = TableColumn.deserialize(node);
        break;
      case 'row-for':
        result = RowFor.deserialize(node);
        break;
      case 'qrcode':
        result = QRCodeBox.deserialize(node);
        break;
      case 'page':
        result = PrinterPage.deserialize(node);
        break;
      case 'barcode':
        result = BarcodeBox.deserialize(node);
        break;
      case 'image':
        result = ImageBox.deserialize(node);
        break;
    }
    if (result == null) {
      throw 'Unsupported control type $type';
    }
    // if (node.getAttribute('if') != null && result.tagName != 'row-for' && result.tagName != 'table' && result.tagName != 'table-column') {
    //   var ifNode = IfBox.deserialize(node);
    //   ifNode.child = result;
    //   return ifNode;
    // }
    return result;

  }

  static ControlBase createForXml(String xmlStr) {
    final XmlDocument xml = XmlDocument.parse(xmlStr); 
    
    return ControlBase.create(xml.rootElement);
  }

  /// 设置的坐标,参与具体计算
  PrinterOffset? offset;
  
  /// 设置的大小, 参与具体计算
  PrinterSize? size;

  /// 标签的名字,主要用于xml编码
  String get tagName;

  /// 是否可以调整宽度
  bool get supportResizeWidth => true;

  /// 是否可以调整高度
  bool get supportResizeHeight => true;

  /// 实际坐标, 执行performLayout后得出
  PrinterOffset? actualOffset;

  /// 实际大小, 执行performLayout后得出
  PrinterSize? actualSize;

  /// 是否溢出了父控件
  bool overflow = false;

  /// 数据源
  DataSourceBase? dataSource;

  String? condition;

  /// 判断是否渲染
  bool get isRender {
    if (condition == null || this.tagName == 'row-for' || this.tagName == 'table' || this.tagName == 'table-column') {
      return true;
    }
    
    return this.dataSource!.execExpressionToValue(condition!) ?? false;
  }

  ControlBase();

  ControlBase.deserialize(XmlElement node) {
    condition = node.getAttribute('if');
    double x = double.tryParse(node.getAttribute('x') ?? '') ?? 0;
    double y = double.tryParse(node.getAttribute('y') ?? '') ?? 0;
    var widthStr = node.getAttribute('width') ?? '';
    double? width;
    if (widthStr != 'auto') {
       width = double.tryParse(widthStr) ?? double.infinity;
    }
    var heightStr = node.getAttribute('height') ?? '';
    double? height;
    if (heightStr != 'auto') {
       height = double.tryParse(heightStr) ?? double.infinity;
    }

    offset = PrinterOffset(x, y);

    size = PrinterSize(width, height);
  }
  
  serialize(XmlBuilder builder) {
    if (offset != null) {
      if (offset!.x != 0 && offset!.x != null) {
        builder.attribute('x', offset!.x!);
      }
      if (offset!.y != 0 && offset!.y != null) {
        builder.attribute('y', offset!.y!);
      }
    }
    if (size != null) {
      if (size!.width != double.infinity && size!.width != null) {
        builder.attribute('width', size!.width!);
      }
      if (size!.height != double.infinity && size!.height != null) {
        builder.attribute('height', size!.height!);
      }
    }
    if (condition != null) {
      builder.attribute('if', condition!);
    }
  }

  /// 设置数据源
  setDataSource(DataSourceBase dataSource) {
    this.dataSource = dataSource;
  }

  /// 布局
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    actualOffset = offset;
    actualSize = constraints.constrain(size!);
  }

  /// 渲染
  paint(PrinterCanvas canvas, PrinterOffset offset);
}