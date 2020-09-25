part of rare_print;

class TscCanvas extends DeviceCanvas {
  @override
  PrinterSize? pageSize;

  @override
  CommandType get commandType => CommandType.TSCL;

  TscCanvas() {
    this.addFont(PrinterFontType(
      "宋体",
      'TSS24.BF2',
      24,
      24,
    ));
    this.config = PrinterConfig(
        pageInfo: PageInfo(
        gapmMM: 0,
        gapnMM: 0,
        pageCount: 1
      ),
        fontStyle: PrinterTextStyle(
            align: AlignEnum.start,
            fontType: 'TSS24.BF2',
            fontSize: 1,
            fontBlod: false,
            underline: false,
            lineSpace: 4,
            lineHeight: 1.2));
  }

  @override
  drawBarCode(String context, PrinterOffset offset, int height, [int lineWidth = 1]) {
    lineWidth++;
    addCommand(
        "BARCODE ${offset.x!.toInt()},${offset.y!.toInt()},128,$height,0,0,$lineWidth,${lineWidth * 2},$context");
  }

  @override
  drawLine(PrinterOffset offset, PrinterSize size) {
    addCommand(
        "BAR ${offset.x!.toInt()},${offset.y!.toInt()},${size.width!.toInt()},${size.height!.toInt()}");
  }

  @override
  drawQRCode(String context, PrinterOffset offset, PrinterSize size, ECCLevelEnum ecc) {
    final qrCode = QrCode.fromData(data: context, errorCorrectLevel: eccToLibNumber(ecc));
    int zoom = size.width! ~/ qrCode.moduleCount;
    
    if (zoom == 0) {
      throw new Exception("宽度太小");
    }
    if (zoom > 10) {
      zoom = 10;
    }

    int viewOffset = (size.width! - zoom * qrCode.moduleCount) ~/ 2;

    addCommand(
        'QRCODE ${offset.x!.toInt() + viewOffset},${offset.y!.toInt() + viewOffset},${eccToString(ecc)},$zoom,A,0,"$context"');
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
      var data = List<int>.filled(size.width! * size.height! ~/ 8, 0);
      var k = 0;
      for (var y = 0; y < bytes.length;y++) {
        var rowBytes = List<bool>.from(bytes[y]);
        for (var x = 0; x < rowBytes.length; x += 8) {
          if (rowBytes.length < x + 8) {
            rowBytes.addAll(List<bool>.filled((x + 8) - rowBytes.length, false));
          }
          var b0 = _p0[rowBytes[x] == true ? 0 : 1];
          var b1 = _p1[rowBytes[x + 1] == true ? 0 : 1];
          var b2 = _p2[rowBytes[x + 2] == true ? 0 : 1];
          var b3 = _p3[rowBytes[x + 3] == true ? 0 : 1];
          var b4 = _p4[rowBytes[x + 4] == true ? 0 : 1];
          var b5 = _p5[rowBytes[x + 5] == true ? 0 : 1];
          var b6 = _p6[rowBytes[x + 6] == true ? 0 : 1];
          var b7 = _p7[rowBytes[x + 7] == true ? 0 : 1];
          
          var temp = b0 + b1 + b2 + b3 + b4 + b5 + b6 + b7;
          data[k] = temp;
          k++;
        }
      }

      this.addCommand('BITMAP ${offset.x!.toInt()},${offset.y!.toInt()},${size.width! ~/ 8},${size.height!.toInt()},0,', addEnd: false);
      this.buffer.addAll(data);
      this.addCommand('');
  }


  @override
  drawText(String? text, PrinterOffset offset, PrinterSize size, PrinterTextStyle textStyle) {

    textStyle = textStyle.extendsStyle(this.config!.fontStyle!);

    var fontHeight = getFontHeight(textStyle);
    var height = fontHeight.toDouble() * (textStyle.lineHeight ?? 1);

    if (text == null || text.trim().isEmpty) {
      return offset.y! + height;
    }

    var textLeft =
        this.calcTextLeft(text, size.width!.toInt(), textStyle.align!, textStyle);
    if (textLeft < 0) {
      text = splitLine(text, size.width!.toInt(), textStyle)[0];
      textLeft = this
          .calcTextLeft(text, size.width!.toInt(), textStyle.align!, textStyle);
    }
    var x = offset.x! + textLeft;
    var y = offset.y! + (height - fontHeight) ~/ 2;

    if (text.trim().isNotEmpty) {
      this.addCommand(
          'TEXT ${x.toInt()},${y.toInt()},"${textStyle.fontType}",0,${textStyle.fontSize},${textStyle.fontSize},"$text"');
    }
  }

  @override
  end() {}

  @override
  reset() {
    buffer.clear();
  }

  @override
  List<int> toCommand() {
    List<int> result = [];
    int pageWidth = pageSize!.width! ~/ 8 + 2;
    int pageHeight = pageSize!.height! ~/ 8 + 2;
    //设置纸张
    this.addCommand('SIZE $pageWidth mm,$pageHeight mm\r\n', buffer: result);
    // 设置标签间隙，按照实际尺寸设置，如果为无间隙纸则设置为0
    this.addCommand("GAP ${config!.pageInfo!.gapmMM} mm,${config!.pageInfo!.gapnMM} mm\r\n", buffer: result);
    // 设置打印方向  BACKWARD(1)  NORMAL(0)
    this.addCommand("DIRECTION 1,0\r\n", buffer: result);
    //设置原始坐标   0,0
    this.addCommand("REFERENCE 0,0\r\n", buffer: result);
    // 撕纸模式开启
    this.addCommand("SET TEAR 1\r\n", buffer: result);
    // 清除打印缓冲区
    this.addCommand("CLS\r\n", buffer: result);

    result.addAll(buffer);

    this.addCommand("PRINT 1,${config!.pageInfo!.pageCount}\r\n", buffer: result);
    this.addCommand("SOUND 2,100\r\n", buffer: result);
    this.addCommand("CASHDRAWER 1,255,255\r\n", buffer: result);

    return result;
  }

  insertCommand(int index, String str, {List<int>? buffer}) {
    if (buffer == null) {
      buffer = this.buffer;
    }
    buffer.insertAll(index, uint16To8(gbk.encode(str + '\r\n')));
  }

  addCommand(String str, {List<int>? buffer, bool addEnd = true}) {
    if (buffer == null) {
      buffer = this.buffer;
    }
    if (addEnd) {
      str += '\r\n';
    }
    buffer.addAll(uint16To8(gbk.encode(str)));
  }

  uint16To8(List<int> bytes) {
    List<int> result = [];
    for (int i = 0; i < bytes.length; i++) {
      if (bytes[i] <= 255) {
        result.add(bytes[i]);
      } else {
        result.addAll([bytes[i] >> 8, bytes[i] & 255]);
      }
    }
    return result;
  }
}
