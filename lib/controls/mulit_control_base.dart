part of rare_print;

abstract class MultiControlBase<T extends ControlBase> extends ControlBase {
  List<T> children = [];

  MultiControlBase(): super();

  MultiControlBase.deserialize(XmlElement node, [List<String> filterTag = const []]) : super.deserialize(node){
    for (var child in node.children) {
      if (child is XmlElement) {
        if (!filterTag.contains(child.name.local)) {
          children.add(ControlBase.create(child) as T);
        }
      }
    }
  }
  
  @override
  serialize(XmlBuilder builder) {
    super.serialize(builder);
    for (var child in children) {
      builder.element(child.tagName, nest: () {
        child.serialize(builder);
      });
    }
  }

  @override
  setDataSource(DataSourceBase dataSource) {
    super.setDataSource(dataSource);
    for (var child in children) {
      child.setDataSource(dataSource);
    }  
  }
  
  @override
  paint(PrinterCanvas canvas, PrinterOffset offset) {
    for (var child in children) {
      if (child.isRender) {
        child.paint(canvas, offset + this.actualOffset!);
      }
    }
  }
}