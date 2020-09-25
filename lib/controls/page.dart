part of rare_print;


class PrinterPage extends MultiControlBase {
  List<EvalProperty> evalPropertys = [];
  PrinterConfig? printerConfig;
  List<PrinterFontType> fontTypes = [];

  PrinterPage({this.printerConfig})
    : super();

  PrinterPage.deserialize(XmlElement node)
      : super.deserialize(node, ['eval-property', 'printer-config', 'font-type']) {
    assert(this.children.isNotEmpty, 'Page必须要有下级');
    assert(this.children.length == 1, 'Page的下级只能有一个');
    for (var child in node.children) {
      if (child is XmlElement) {
        if (child.name.local == 'eval-property') {
          evalPropertys.add(EvalProperty.deserialize(child));
        } else if (child.name.local == 'printer-config') {
          printerConfig = PrinterConfig.deserialize(child);
        } else if (child.name.local == 'font-type') {
          fontTypes.add(PrinterFontType.deserialize(child));
        }
      }
    }
  }

  @override
  performLayout(PrinterConstraints constraints, PrinterCanvas canvas) {
    if (printerConfig != null) {
      if (canvas.config != null) {
        canvas.config = printerConfig!.extendsStyle(canvas.config!);
      } else {
        canvas.config = printerConfig;
      }
    }
    for (var fontType in fontTypes) {
      canvas.addFont(fontType);
    }
    super.performLayout(constraints, canvas);
    constraints = PrinterConstraints.loose(actualSize!);
    var maxWidth = actualSize!.width!.isInfinite ? 0 : actualSize!.width;
    var maxHeight = actualSize!.height!.isInfinite ? 0 : actualSize!.height;
    for (var child in children) {
      if (child.isRender) {
        child.performLayout(constraints, canvas);
        maxWidth= Math.max(child.actualSize!.width!, maxWidth!);
        maxHeight= Math.max(child.actualSize!.height!, maxHeight!);
      }
    }
    actualSize = PrinterSize(maxWidth!.toDouble(), maxHeight!.toDouble());
  }

  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    for (var property in evalPropertys) {
      builder.element('eval-property', nest: () {
        property.serialize(builder);
      });
    }
  }

  /// 设置数据源
  @override
  setDataSource(DataSourceBase dataSource) {
    this.dataSource = dataSource;
    for (var property in evalPropertys) {
      property.eval(dataSource);
    }
    super.setDataSource(dataSource);
  }

  @override
  String get tagName => 'page';

  
  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    if (printerConfig != null) {
      if (canvas.config != null) {
        canvas.config = printerConfig!.extendsStyle(canvas.config!);
      } else {
        canvas.config = printerConfig;
      }
    }
    for (var fontType in fontTypes) {
      canvas.addFont(fontType);
    }
    super.paint(canvas, offset);
  }
}

class EvalProperty {
  /// 依附的对象, 如果是List则也是相对路径
  String? attch;

  /// 字段名
  String propertyName;

  /// 执行表达式
  String expression;

  EvalProperty.deserialize(XmlElement node)
    :attch = node.getAttribute('attch'),
     propertyName = node.getAttribute('propertyName')!,
     expression = node.innerText.trim();

  serialize(XmlBuilder builder) {
    if (attch != null) {
      builder.attribute('attch', attch!);
    }
    builder.attribute('propertyName', propertyName);
    builder.text(expression);
  }

  eval(DataSourceBase dataSource) {
    var data;
    if (attch == null || attch == '') {
      data = dataSource.dataSource;
    } else {
      data = dataSource.execExpressionToValue(attch!);
    }
    if (data is Map) {
      _evalObj(dataSource, data);
    } else if (data is List) {
      _evalList(data, dataSource);
    } else {
      throw '只支持依附在Map 和 List<Map>';
    }
  }

  _evalList(List data, DataSourceBase dataSource) {
    for (int i = 0; i < data.length; i++) {
      if (data[i] is List) {
        _evalList(data[i], dataSource);
      } else {
        var rowDataSource = RowDataSource(data[i], dataSource, i);
        _evalObj(rowDataSource, data[i]);
      }
    }
  }

  _evalObj(DataSourceBase dataSource, Map data) {
    data[propertyName] = dataSource.execExpressionToValue(expression);
  }
}
