part of rare_print;

class PrinterConfig {
  /// 字体样式
  final PrinterTextStyle? fontStyle;

  /// 页面信息
  final PageInfo? pageInfo;

  const PrinterConfig({this.fontStyle, this.pageInfo});

  
  PrinterConfig.deserialize(XmlElement xml):
      this.fontStyle =  PrinterTextStyle.deserialize(xml),
      this.pageInfo = xml.getElement('page-info') != null ? PageInfo.deserialize(xml.getElement('page-info')!) : PageInfo();

  

  PrinterConfig extendsStyle(PrinterConfig style) {
    var fontStyle = this.fontStyle;
    var pageInfo = this.pageInfo;
    if (fontStyle != null) {
      if (style.fontStyle != null) {
        fontStyle = fontStyle.extendsStyle(style.fontStyle!);
      }
    } else {
      fontStyle = style.fontStyle;
    }
    if (pageInfo != null) {
      if (style.pageInfo != null) {
        pageInfo = pageInfo.extendsStyle(style.pageInfo!);
      }
    } else {
      pageInfo = style.pageInfo;
    }
    return PrinterConfig(
      fontStyle: fontStyle,
      pageInfo: pageInfo
    );
  }

  
  PrinterConfig copyWith({PrinterTextStyle? fontStyle, PageInfo? pageInfo}) {
    if (fontStyle != null) {
      if (this.fontStyle != null) {
        fontStyle = fontStyle.extendsStyle(this.fontStyle!);
      }
    }
    if (pageInfo != null) {
      if (this.pageInfo != null) {
        pageInfo = pageInfo.extendsStyle(this.pageInfo!);
      }
    }
    return PrinterConfig(
      fontStyle: fontStyle ?? this.fontStyle,
      pageInfo: pageInfo ?? this.pageInfo
    );
  }
}

class PageInfo {
  /// 间隙M (TSC)
  final int? gapmMM;
  /// 间隙N (TSC)
  final int? gapnMM;
  /// 重复打印次数
  final int? pageCount;

  PageInfo({this.gapmMM, this.gapnMM, this.pageCount});

  
  PageInfo.deserialize(XmlElement xml):
      gapmMM = int.tryParse(xml.getAttribute('gapmMM') ?? ''),
      gapnMM = int.tryParse(xml.getAttribute('gapnMM') ?? ''),
      pageCount = int.tryParse(xml.getAttribute('pageCount') ?? '');

  

  PageInfo extendsStyle(PageInfo style) {
    return PageInfo(
      gapmMM: this.gapmMM ?? style.gapmMM,
      gapnMM: this.gapnMM ?? style.gapnMM,
      pageCount: this.pageCount ?? style.pageCount,
    );
  }

  
  PageInfo copyWith({int? gapmMM, int? gapnMM, int? pageCount}) {
    return PageInfo(
      gapmMM:  gapmMM ?? this.gapmMM,
      gapnMM:  gapnMM ?? this.gapnMM,
      pageCount:  pageCount ?? this.pageCount,
    );
  }
}