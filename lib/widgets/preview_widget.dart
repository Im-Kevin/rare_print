

import 'package:flutter/material.dart';
import '../rare_print.dart';

class PreviewWidget extends StatefulWidget {
  final ControlBase control;

  const PreviewWidget({Key? key,required this.control}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PreviewWidgetState();
  }
}

class PreviewWidgetState extends State<PreviewWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PreviewPainter(widget.control),
    );
  }

  @override
  void didUpdateWidget(covariant PreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.control != widget.control) {
      setState(() {
        
      });
    }
  }
}

class _PreviewPainter extends CustomPainter {
  final ControlBase control;

  _PreviewPainter(this.control);

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(control.actualSize!.width!, control.actualSize!.height!);
    Border border = Border.all();
    border.paint(canvas, Offset.zero & size);

    PreviewCanvas previewCanvas = PreviewCanvas();
    previewCanvas.pageSize = control.actualSize;
    previewCanvas.reset();
    
    control.paint(previewCanvas, PrinterOffset.zero);

    previewCanvas.end();
    Paint paint = Paint();
    paint.color = Color(0xFF000000);
    canvas.drawPicture(previewCanvas.picture!);
    previewCanvas.picture!.dispose();
    // canvas.drawRect(PrinterOffset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter oldDelegate) {
    return oldDelegate.control != this.control;
  }
}
