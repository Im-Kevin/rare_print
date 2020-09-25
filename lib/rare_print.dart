library rare_print;

import 'package:decimal/decimal.dart';
import 'package:expressions/expressions.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:intl/intl.dart';
import 'package:qr/qr.dart';
import 'dart:math' as Math;
import 'package:xml/xml.dart';

import 'utils/string_utils.dart';

export 'widgets/preview_widget.dart';
export 'paintings/preview_canvas.dart';

part 'data_sources/data_structure.dart';
part 'data_sources/data_source_base.dart';

part 'ui_lib/geometry.dart';

part 'paintings/barcode.dart';
part 'paintings/printer_config.dart';
part 'paintings/cpcl_canvas.dart';
part 'paintings/device_canvas.dart';
part 'paintings/printer_canvas.dart';
part 'paintings/tsc_canvas.dart';
part 'paintings/child_canvas.dart';

part 'controls/if_box.dart';

part 'controls/barcode_box.dart';
part 'controls/column_box.dart';
part 'controls/control_base.dart';
part 'controls/line_box.dart';
part 'controls/mulit_control_base.dart';
part 'controls/page.dart';
part 'controls/qrcode_box.dart';
part 'controls/row_box.dart';
part 'controls/row_for.dart';
part 'controls/stack_box.dart';
part 'controls/table_box.dart';
part 'controls/text_box.dart';
part 'controls/image_box.dart';
