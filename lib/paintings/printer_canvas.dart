part of rare_print;

const List<int> _p0 = [0, 128];
const List<int> _p1 = [0, 64];
const List<int> _p2 = [0, 32];
const List<int> _p3 = [0, 16];
const List<int> _p4 = [0, 8];
const List<int> _p5 = [0, 4];
const List<int> _p6 = [0, 2];
const List<int> _p7 = [0, 1];

abstract class PrinterCanvas {
  PrinterConfig? config = PrinterConfig(
      fontStyle: PrinterTextStyle(
          align: AlignEnum.start,
          fontType: '24',
          fontSize: 1,
          fontBlod: false,
          underline: false,
          lineSpace: 4,
          lineHeight: 1.2));

  PrinterSize? get pageSize;
  set pageSize(PrinterSize? value);

  PrinterConfig? get defaultConfig {
    return config;
  }

  Map<String, PrinterFontType> _fontMap = {};

  addFont(PrinterFontType fontType) {
    this._fontMap[fontType.fontType] = fontType;
  }

  /// 重置
  reset();

  /// 结束
  end();

  ///
  /// 打印文字
  ///
  /// [text] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [size] 大小
  ///
  /// [textStyle] 文字样式
  drawText(String? text, PrinterOffset offset, PrinterSize size,
      PrinterTextStyle textStyle);

  ///
  /// 打印线条
  ///
  /// [offset] 偏移位置
  ///
  /// [size] 大小
  drawLine(PrinterOffset offset, PrinterSize size);

  ///
  /// 打印二维码
  ///
  /// [context] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [height] 高度
  ///
  /// [lineWidth] 窄条的单位宽度,默认1
  drawBarCode(String context, PrinterOffset offset, int height,
      [int lineWidth = 1]);

  ///
  /// 打印二维码
  ///
  /// [context] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [size] 大小
  ///
  /// [lineWidth] 窄条的单位宽度,默认1
  ///
  /// [align] 位置,默认居中
  drawBarCodeForSize(String? context, PrinterOffset offset, PrinterSize size,
      [int lineWidth = 1, AlignEnum align = AlignEnum.center]) {
    var width = this.getBarCodeWidth(context!, lineWidth);

    double x = offset.x!;
    double y = offset.y!;

    switch (align) {
      case AlignEnum.center:
        x += (size.width! - width) / 2;
        break;
      case AlignEnum.end:
        x += size.width! - width;
        break;
      default:
        break;
    }
    this.drawBarCode(
        context, PrinterOffset(x, y), size.height!.toInt(), lineWidth);
  }

  ///
  /// 打印二维码
  ///
  /// [context] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [size] 大小
  ///
  /// [ecc] 纠错等级
  drawQRCode(
      String context, PrinterOffset offset, PrinterSize size, ECCLevelEnum ecc);

  /// 打印图片
  ///
  /// [context] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [bytes] 位图内容, true:代表黑色 false:代表白色 二维数组 第一维纵 第二维横
  drawBitmap(PrinterOffset offset, PrinterSize size, List<List<bool>> bytes);

  drawQRCodeBitmap(String context, PrinterOffset offset, PrinterSize size,
      ECCLevelEnum ecc) {
    double width = size.width!;
    if (width % 8 != 0) {
      /// 宽度不是8的倍数则进1
      width = (width ~/ 8 + 1) * 8.0;
    }
    final qrCode =
        QrCode.fromData(data: context, errorCorrectLevel: eccToLibNumber(ecc));
    qrCode.make();
    int zoom = size.width! ~/ qrCode.moduleCount;
    int viewOffset = (size.width! - zoom * qrCode.moduleCount) ~/ 2;
    var bytes = List<List<bool>>.generate(size.height!.toInt(),
        (_) => List<bool>.filled(size.width!.toInt(), false));
    for (int x = 0; x < qrCode.moduleCount; x++) {
      for (int y = 0; y < qrCode.moduleCount; y++) {
        if (qrCode.isDark(y, x) == true) {
          int baseX = x * zoom + viewOffset;
          int baseY = y * zoom + viewOffset;
          for (int j = 0; j < zoom; j++) {
            bytes[baseY + j].fillRange(baseX, baseX + zoom, true);
          }
          // render a dark square on the canvas
        }
      }
    }
    this.drawBitmap(offset, PrinterSize(width, size.height), bytes);
  }

  ///
  /// 获取字体宽度
  ///
  /// [fontType] 字体类型
  ///
  /// [fontSize] 字体大小
  int getFontWidth(PrinterTextStyle style) {
    return style.fontSize! * _fontMap[style.fontType!]!.fontBaseWidth;
  }

  ///
  /// 获取字体高度
  ///
  /// [fontType] 字体类型
  ///
  /// [fontSize] 字体大小
  int getFontHeight(PrinterTextStyle style) {
    return style.fontSize! * _fontMap[style.fontType!]!.fontBaseHeight;
  }

  ///
  /// 获取字体名称
  /// 
  /// [fontType] 字体类型
  /// 
  String getFontName(PrinterTextStyle style) {
    return _fontMap[style.fontType!]!.fontName;
  }

  ///
  /// 获取字体宽度 Ascii
  ///
  /// [style] 文字样式
  int getFontAsciiWidth(PrinterTextStyle style) {
    return this.getFontWidth(style) ~/ 2;
  }

  int getTextLineHeight(PrinterTextStyle style) {
    return (this.getFontHeight(style) * style.lineHeight!).toInt();
  }

  ///
  /// 计算文字左侧位置
  ///
  /// [text] 文字
  ///
  /// [width] 总宽度
  ///
  /// [fontAlign] 文字位置
  ///
  /// [style] 文字样式
  int calcTextLeft(
      String text, int width, AlignEnum fontAlign, PrinterTextStyle style) {
    if (fontAlign == AlignEnum.start) {
      return 0;
    }
    var textWidth = this.getTextWidth(text, style);

    switch (fontAlign) {
      case AlignEnum.center:
        return (width - textWidth) ~/ 2;
      case AlignEnum.end:
        return width - textWidth;
      default:
        return 0;
    }
  }

  ///
  /// 获取text限制在contentWidth后的长度
  ///
  /// [text] 文字
  ///
  /// [contentWidth] 限制范围
  ///
  /// [style] 文字样式
  int estimateLength(String text, int contentWidth, PrinterTextStyle style) {
    int ascCharWidth = this.getFontAsciiWidth(style);
    int cnCharWidth = this.getFontWidth(style);
    int width = 0;
    int i = 0;
    List<int> codeUnits = text.codeUnits;
    for (int len = codeUnits.length; i < len; i++) {
      int charCode = codeUnits[i];
      var charWidth =
          (0 <= charCode && charCode <= 127) ? ascCharWidth : cnCharWidth;

      if (charWidth + width <= contentWidth) {
        width += charWidth;
      } else {
        break;
      }
    }
    return i;
  }

  ///
  /// 获取文字宽度
  ///
  /// [text] 文字
  ///
  /// [style] 文字样式
  int getTextWidth(String text, PrinterTextStyle style) {
    int ascCharWidth = this.getFontAsciiWidth(style);
    int cnCharWidth = this.getFontWidth(style);
    int width = 0;
    int i = 0;
    List<int> codeUnits = text.codeUnits;
    for (int len = codeUnits.length; i < len; i++) {
      int charCode = codeUnits[i];
      width += (0 <= charCode && charCode <= 127) ? ascCharWidth : cnCharWidth;
    }
    return width;
  }

  ///
  /// 文字自动换行裁剪
  ///
  /// [str] 文字
  ///
  /// [contentWidth] 限制范围
  ///
  /// [style] 文字样式
  List<String> splitLine(String str, int contentWidth, PrinterTextStyle style) {
    int cnCharWidth = this.getFontWidth(style);
    if (contentWidth < cnCharWidth) { // 如果宽度小于字体宽度,则每行一个
      return str.split('');
    }
    List<String> result = <String>[];

    while (str != "") {
      var length = this.estimateLength(str, contentWidth, style);
      result.add(str.substring(0, length));
      str = str.substring(length);
    }

    return result;
  }

  ///
  /// 计算条码宽度
  ///
  /// [context] 内容
  ///
  /// [lineWidth] 窄条的单位宽度,默认1
  int getBarCodeWidth(String context, int lineWidth) {
    var barcode = new Code128(context);
    return barcode.getEncoding().length * (lineWidth + 1);
  }

  ///
  /// 创建子Canvas
  ///
  PrinterCanvas createChild(PrinterConfig config) {
    var result = ChildCanvas(this);
    result.config = config;
    return result;
  }
}

class PrinterFontType {
  /// 预览显示时的格式
  final String fontName;

  /// 字体类型 默认: 1(编译给指令用的)
  final String fontType;

  /// 字体大小1的时候的宽度
  final int fontBaseWidth;

  /// 字体大小1的时候的高度
  final int fontBaseHeight;

  const PrinterFontType(this.fontName, this.fontType, this.fontBaseWidth, this.fontBaseHeight);

  PrinterFontType.deserialize(XmlElement xml)
      : this.fontName = xml.getAttribute('fontName') ?? '',
        this.fontType = xml.getAttribute('fontType') ?? '',
        this.fontBaseWidth =
            int.tryParse(xml.getAttribute('fontBaseWidth') ?? '')!,
        this.fontBaseHeight =
            int.tryParse(xml.getAttribute('fontBaseHeight') ?? '')!;

  serialize(XmlBuilder builder) {
      builder.attribute('fontName', this.fontName);
      builder.attribute('fontType', this.fontType);
      builder.attribute('fontBaseWidth', this.fontBaseWidth);
      builder.attribute('fontBaseHeight', this.fontBaseHeight);
  }
}

/// 字体样式
class PrinterTextStyle {
  /// 文字位置
  final AlignEnum? align;

  /// 字体类型 默认: 1
  final String? fontType;

  /// 字体大小 默认: 1
  final int? fontSize;

  /// 是否粗体 false
  final bool? fontBlod;

  /// 是否删除线
  final bool? underline;

  /// 行距
  final int? lineSpace;

  /// 行高
  final double? lineHeight;

  PrinterTextStyle(
      {this.align,
      this.fontType,
      this.fontSize,
      this.fontBlod,
      this.underline,
      this.lineSpace,
      this.lineHeight});

  PrinterTextStyle.deserialize(XmlElement xml)
      : this.align = stringToAlign(xml.getAttribute('align') ?? ''),
        this.fontType = xml.getAttribute('fontType'),
        this.fontSize = int.tryParse(xml.getAttribute('fontSize') ?? ''),
        this.fontBlod = stringToBool(xml.getAttribute('fontBlod') ?? ''),
        this.underline = stringToBool(xml.getAttribute('underline') ?? ''),
        this.lineSpace = int.tryParse(xml.getAttribute('lineSpace') ?? ''),
        this.lineHeight = double.tryParse(xml.getAttribute('lineHeight') ?? '');

  PrinterTextStyle copyWith(
     {int? fontBaseWidth,
      int? fontBaseHeight,
      AlignEnum? align,
      String? fontType,
      int? fontSize,
      bool? fontBlod,
      bool? underline,
      int? lineSpace,
      double? lineHeight}) {
    return PrinterTextStyle(
      align: align ?? this.align,
      fontType: fontType ?? this.fontType,
      fontSize: fontSize ?? this.fontSize,
      fontBlod: fontBlod ?? this.fontBlod,
      underline: underline ?? this.underline,
      lineSpace: lineSpace ?? this.lineSpace,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  PrinterTextStyle extendsStyle(PrinterTextStyle style) {
    return PrinterTextStyle(
      align: this.align ?? style.align,
      fontType: this.fontType ?? style.fontType,
      fontSize: this.fontSize ?? style.fontSize,
      fontBlod: this.fontBlod ?? style.fontBlod,
      underline: this.underline ?? style.underline,
      lineSpace: this.lineSpace ?? style.lineSpace,
      lineHeight: this.lineHeight ?? style.lineHeight,
    );
  }

  serialize(XmlBuilder builder) {
    if (align != null) {
      builder.attribute('align', this.align!);
    }
    if (fontType != null) {
      builder.attribute('fontType', this.fontType!);
    }
    if (fontSize != null) {
      builder.attribute('fontSize', this.fontSize!);
    }
    if (fontBlod != null) {
      builder.attribute('fontBlod', this.fontBlod!);
    }
    if (underline != null) {
      builder.attribute('underline', this.underline!);
    }
    if (lineSpace != null) {
      builder.attribute('lineSpace', this.lineSpace!);
    }
    if (lineHeight != null) {
      builder.attribute('lineHeight', this.lineHeight!);
    }
  }
}

/// 纠错等级
enum ECCLevelEnum {
  /// 7%
  L,

  /// 15%
  M,

  /// 25%
  Q,

  /// 30%
  H
}

int eccToLibNumber(ECCLevelEnum ecc) {
  switch (ecc) {
    case ECCLevelEnum.L:
      return 1;
    case ECCLevelEnum.M:
      return 0;
    case ECCLevelEnum.Q:
      return 3;
    case ECCLevelEnum.H:
      return 2;
    default:
      throw '未知错误';
  }
}

ECCLevelEnum stringToECC(String str) {
  switch (str.trim().toLowerCase()) {
    case 'L':
      return ECCLevelEnum.L;
    case 'M':
      return ECCLevelEnum.M;
    case 'Q':
      return ECCLevelEnum.Q;
    case 'H':
      return ECCLevelEnum.H;
    default:
      return ECCLevelEnum.M;
  }
}

String eccToString(ECCLevelEnum ecc) {
  switch (ecc) {
    case ECCLevelEnum.L:
      return 'L';
    case ECCLevelEnum.M:
      return 'M';
    case ECCLevelEnum.Q:
      return 'Q';
    case ECCLevelEnum.H:
      return 'H';
    default:
      throw '未知错误';
  }
}

enum AlignEnum {
  /// 左
  start,

  /// 居中
  center,

  /// 右侧
  end
}

AlignEnum? stringToAlign(String? str) {
  if (str == null) {
    return null;
  }
  switch (str.trim().toLowerCase()) {
    case 'start':
      return AlignEnum.start;
    case 'center':
      return AlignEnum.center;
    case 'end':
      return AlignEnum.end;
    default:
      return null;
  }
}

String alignToString(AlignEnum align) {
  switch (align) {
    case AlignEnum.start:
      return 'start';
    case AlignEnum.center:
      return 'center';
    case AlignEnum.end:
      return 'end';
    default:
      throw '未知错误';
  }
}

bool? stringToBool(String? str) {
  if (str == null) {
    return null;
  }
  if (str.trim().toLowerCase() == 'false') {
    return false;
  }
  if (str.trim().toLowerCase() == 'true') {
    return true;
  }
  return null;
}
