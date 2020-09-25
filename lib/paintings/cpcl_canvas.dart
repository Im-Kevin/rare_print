part of rare_print;

class CPCLCanvas extends DeviceCanvas {
  PrinterSize? pageSize;

  int? _fontSize;
  bool? _fontBlod;
  bool? _underline;

  @override
  CommandType get commandType => CommandType.CPCL;

  CPCLCanvas() {
    this.addFont(PrinterFontType(
      "宋体",
      '24',
      24,
      24,
    ));
    this.config = PrinterConfig(
        fontStyle: PrinterTextStyle(
            align: AlignEnum.start,
            fontType: '24',
            fontSize: 1,
            fontBlod: false,
            underline: false,
            lineSpace: 4,
            lineHeight: 1.2));
  }

  @override
  reset() {
    buffer.clear();
    setFontSize(0);
    setFontBlod(false);
    setUnderline(false);
  }

  @override
  drawBarCode(String context, PrinterOffset offset, int height, [int lineWidth = 1]) {
    addCommand("B 128 $lineWidth 1 $height ${offset.x} ${offset.y} $context");
  }

  @override
  drawLine(PrinterOffset offset, PrinterSize size) {
    var rect = offset & size;
    addCommand(
        "L ${rect.left} ${rect.top} ${rect.right} ${rect.bottom} ${Math.min(size.width!, size.height!)}");
  }

  @override
  drawQRCode(String context, PrinterOffset offset, PrinterSize size, ECCLevelEnum ecc) {
    final qrCode = QrCode.fromData(data: context, errorCorrectLevel: eccToLibNumber(ecc));
    int zoom = size.width! ~/ qrCode.moduleCount;
    
    if (zoom == 0) {
      throw new Exception("宽度太小");
    }
    if (zoom > 32) {
      zoom = 32;
    }

    int viewOffset = (size.width! - zoom * qrCode.moduleCount) ~/ 2;

    addCommand(
        "B QR ${offset.x!.toInt() + viewOffset} ${offset.y!.toInt() + viewOffset} U $zoom");
    addCommand("${_eccToStr(ecc)}A,$context");
    addCommand("ENDQR");
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
          var b0 = _p0[rowBytes[x] == true ? 1 : 0];
          var b1 = _p1[rowBytes[x + 1] == true ? 1 : 0];
          var b2 = _p2[rowBytes[x + 2] == true ? 1 : 0];
          var b3 = _p3[rowBytes[x + 3] == true ? 1 : 0];
          var b4 = _p4[rowBytes[x + 4] == true ? 1 : 0];
          var b5 = _p5[rowBytes[x + 5] == true ? 1 : 0];
          var b6 = _p6[rowBytes[x + 6] == true ? 1 : 0];
          var b7 = _p7[rowBytes[x + 7] == true ? 1 : 0];
          
          var temp = b0 + b1 + b2 + b3 + b4 + b5 + b6 + b7;
          data[k] = temp;
          k++;
        }
      }

      this.addCommand('CG ${size.width! ~/ 8} ${size.height!.toInt()} ${offset.x!.toInt()} ${offset.y!.toInt()} ', addEnd: false);
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

    setFontBlod(textStyle.fontBlod ?? false);
    setUnderline(textStyle.underline ?? false);
    setFontSize(textStyle.fontSize ?? 1);

    var textLeft = this.calcTextLeft(text, size.width!.toInt(), textStyle.align!,
        textStyle);
    if (textLeft < 0) {
      text = splitLine(
          text, size.width!.toInt(), textStyle)[0];
      textLeft = this.calcTextLeft(text, size.width!.toInt(), textStyle.align!,
          textStyle);
    }
    var x = offset.x! + textLeft;
    var y = offset.y! + (height - fontHeight) ~/ 2;

    if (text.trim().isNotEmpty) {
      this.addCommand(
          "T ${textStyle.fontType} 0 ${x.toInt()} ${y.toInt()} $text");
    }
  }

  setFontSize(int fontSize) {
    if (this._fontSize != fontSize) {
      this._fontSize = fontSize;
      addCommand('SETMAG $fontSize $fontSize');
    }
  }

  setFontBlod(bool fontBlod) {
    if (this._fontBlod != fontBlod) {
      this._fontBlod = fontBlod;
      addCommand('SETBLOD ${fontBlod ? 1 : 0}');
    }
  }

  setUnderline(bool underline) {
    if (this._underline != underline) {
      this._underline = underline;
      addCommand('UNDERLINE ${underline ? 'ON' : 'OFF'}');
    }
  }

  String toHexString() {
    return buffer.map((e) {
      var str = e.toRadixString(16);
      if (str.length == 1) {
        str = '0' + str;
      }
      return str;
    }).join();
  }

  insertCommand(int index, String str) {
    buffer.insertAll(index, uint16To8(gbk.encode(str + '\r\n')));
  }

  addCommand(String str, {bool addEnd = true}) {
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

  String _eccToStr(ECCLevelEnum ecc) {
    switch (ecc) {
      case ECCLevelEnum.H:
        return 'H';
      case ECCLevelEnum.L:
        return 'L';
      case ECCLevelEnum.M:
        return 'M';
      case ECCLevelEnum.Q:
        return 'Q';
    }
  }

  @override
  List<int> toCommand() {
    return buffer;
  }

  @override
  end() {
    insertCommand(0, '! 0 200 200 ${(pageSize!.height! + 1).toInt()} 1');
    addCommand('PRINT');
  }
}
