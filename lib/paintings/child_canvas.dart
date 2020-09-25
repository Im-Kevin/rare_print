part of rare_print;

class ChildCanvas extends PrinterCanvas {
  PrinterCanvas _canvas;

  @override
  PrinterSize? pageSize;

  
  @override
  PrinterConfig get defaultConfig {
    return config!.extendsStyle(_canvas.defaultConfig!);
  }

  ChildCanvas(this._canvas);

  @override
  addFont(PrinterFontType fontType) {
    super.addFont(fontType);
    _canvas.addFont(fontType);
  }

  @override
  drawBarCode(String context, PrinterOffset offset, int height, [int lineWidth = 1]) {
    return _canvas.drawBarCode(context, offset, height, lineWidth);
  }

  @override
  drawLine(PrinterOffset offset, PrinterSize size) {
    return _canvas.drawLine(offset, size);
  }

  @override
  drawQRCode(
      String context, PrinterOffset offset, PrinterSize size, ECCLevelEnum ecc) {
    return _canvas.drawQRCode(context, offset, size, ecc);
  }

  /// 打印图片
  ///
  /// [context] 内容
  ///
  /// [offset] 偏移位置
  ///
  /// [bytes] 位图内容, true:代表黑色 false:代表白色 二维数组 第一维纵 第二维横
  @override
  drawBitmap(PrinterOffset offset, PrinterSize size, List<List<bool>> bytes) {
    return _canvas.drawBitmap(offset, size, bytes);
  }

  @override
  drawText(String? text, PrinterOffset offset, PrinterSize size, PrinterTextStyle textStyle) {
    textStyle = textStyle.extendsStyle(this.config!.fontStyle!);
    return _canvas.drawText(text, offset, size, textStyle);
  }

  @override
  end() {
    return _canvas.end();
  }

  @override
  reset() {
    return _canvas.reset();
  }
}
