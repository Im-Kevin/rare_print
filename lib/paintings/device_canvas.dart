part of rare_print;

enum CommandType {
  CPCL,
  TSCL
}

abstract class DeviceCanvas extends PrinterCanvas{
  List<int> buffer = [];

  CommandType get commandType;

  List<int> toCommand();
}