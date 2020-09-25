import '../rare_print.dart';
import 'dart:ui';
import 'package:qr/qr.dart';

abstract class UICanvas extends PrinterCanvas {
  Canvas? get canvas;
  
  @override
  drawBarCode(String context, PrinterOffset offset, int height, [int lineWidth = 1]) {
    var barcode = Code128(context);
    var bits = barcode.getEncoding();

    Paint paint = Paint();
    paint.color = Color(0xFF000000);
    double x = offset.x!;
    lineWidth = lineWidth + 1;
    for (int i = 0; i < bits.length; i++) {
      if (bits[i] == '1') {
        PrinterRect rect = PrinterRect.fromLTWH(
            x, offset.y!, lineWidth.toDouble(), height.toDouble());
        canvas!.drawRect(Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom), paint);
      }
      x += lineWidth;
    }
  }

  @override
  drawLine(PrinterOffset offset, PrinterSize size, [Color color = const Color(0xFF000000)]) {
    Paint paint = Paint();
    paint.color = color;
    canvas!.drawRect(Rect.fromLTWH(offset.x!, offset.y!, size.width!, size.height!), paint);
  }

  @override
  drawQRCode(String context, PrinterOffset offset, PrinterSize size, ECCLevelEnum ecc) {
    Paint paint = Paint();
    paint.color = Color(0xFF000000);

    final qrCode =
        QrCode.fromData(data: context, errorCorrectLevel: eccToLibNumber(ecc));
    qrCode.make();
    int zoom = size.width! ~/ qrCode.moduleCount;
    PrinterSize moduleSize = PrinterSize(zoom.toDouble(), zoom.toDouble());
    for (int x = 0; x < qrCode.moduleCount; x++) {
      for (int y = 0; y < qrCode.moduleCount; y++) {
        if (qrCode.isDark(y, x) == true) {
          var moduleOffset = offset.translate((x * zoom).toDouble(), (y * zoom).toDouble());
          
          canvas!.drawRect(Rect.fromLTWH(moduleOffset.x!, moduleOffset.y!, moduleSize.width!, moduleSize.height!), paint);
          // render a dark square on the canvas
        }
      }
    }
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
    Paint paint = Paint();
    paint.color = Color(0xFF000000);
    for (int y = 0; y < size.height!; y++) {
      for (int x = 0; x < size.width!; x++) {
        if (bytes[y].length > x && bytes[y][x] == true) {
          canvas!.drawRect(Rect.fromLTWH((offset.x! + x).toDouble(), (offset.y! + y).toDouble(), 1, 1), paint);
          // render a dark square on the canvas
        }
      }
    }
  }

  @override
  drawText(String? text, PrinterOffset offset, PrinterSize size, PrinterTextStyle textStyle) {
    if (text == null) {
      return;
    }
    textStyle = textStyle.extendsStyle(this.config!.fontStyle!);

    var fontSize = getFontWidth(textStyle);
    var fontName = getFontName(textStyle);
    TextStyle style = TextStyle(color: Color(0xFF000000));
    TextAlign textAlign;

    switch (textStyle.align) {
      case AlignEnum.start:
        textAlign = TextAlign.left;
        break;
      case AlignEnum.center:
        textAlign = TextAlign.center;
        break;
      case AlignEnum.end:
        textAlign = TextAlign.right;
        break;
      default:
        textAlign = TextAlign.left;
    }

    ParagraphBuilder paragraphBuilder1 = ParagraphBuilder(ParagraphStyle(
        fontFamily: fontName,
        textAlign: textAlign,
        fontSize: fontSize.toDouble(),
        fontWeight: textStyle.fontBlod! ? FontWeight.bold : FontWeight.normal,
        maxLines: 1,
        strutStyle: StrutStyle(
          fontFamily: fontName,
          fontSize: fontSize.toDouble(),
          forceStrutHeight: true,
          height: textStyle.lineHeight,
        )));
    paragraphBuilder1.pushStyle(style);
    paragraphBuilder1.addText(text);
    var paragraph1 = paragraphBuilder1.build()
      ..layout(ParagraphConstraints(width: size.width!));

    canvas!.drawParagraph(paragraph1, Offset(offset.x!, offset.y!));
  }

}

class PreviewCanvas extends UICanvas {
  @override
  PrinterSize? pageSize;

  PictureRecorder? recorder;
  
  @override
  Canvas? canvas;

  Picture? picture;

  @override
  reset() {
    var rect = PrinterRect.fromLTWH(0, 0, pageSize!.width!, pageSize!.height!);
    recorder = PictureRecorder();
    canvas = Canvas(recorder!, Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom));
    picture = null;
  }

  @override
  end() {
    picture = recorder!.endRecording();
    recorder = null;
    canvas = null;
  }
}
