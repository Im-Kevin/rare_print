part of rare_print;

class _CodeData {
  final String value;
  final String a;
  final String b;
  final String c;
  final String encoding;

  String getValue(int index) {
    switch (index) {
      case 0:
        return value;
      case 1:
        return a;
      case 2:
        return b;
      case 3:
        return c;
      case 4:
        return encoding;
      default:
    }
    throw 'index 溢出';
  }

  _CodeData(this.value, this.a, this.b, this.c, this.encoding);
}

enum Code128Type { Auto, A, B, C }

class Code128 {
  List<_CodeData?> _codes = <_CodeData>[];
  List<String> _formattedData = <String>[];
  List<String> _encodedData = <String>[];
  Code128Type _code128Type = Code128Type.Auto;
  
  _CodeData? startCharacter;

  String _data;

  Code128(String data):
    _data = data;

  String getEncoding() {
    initialize();

    return encode();
  }

  initialize() {
    //populate data
    _codes.add(_CodeData("0", " ", " ", "00", "11011001100"));
    _codes.add(_CodeData("1", "!", "!", "01", "11001101100"));
    _codes.add(_CodeData("2", "\"", "\"", "02", "11001100110"));
    _codes.add(_CodeData("3", "#", "#", "03", "10010011000"));
    _codes.add(_CodeData("4", "\$", "\$", "04", "10010001100"));
    _codes.add(_CodeData("5", "%", "%", "05", "10001001100"));
    _codes.add(_CodeData("6", "&", "&", "06", "10011001000"));
    _codes.add(_CodeData("7", "'", "'", "07", "10011000100"));
    _codes.add(_CodeData("8", "(", "(", "08", "10001100100"));
    _codes.add(_CodeData("9", ")", ")", "09", "11001001000"));
    _codes.add(_CodeData("10", "*", "*", "10", "11001000100"));
    _codes.add(_CodeData("11", "+", "+", "11", "11000100100"));
    _codes.add(_CodeData("12", ",", ",", "12", "10110011100"));
    _codes.add(_CodeData("13", "-", "-", "13", "10011011100"));
    _codes.add(_CodeData("14", ".", ".", "14", "10011001110"));
    _codes.add(_CodeData("15", "/", "/", "15", "10111001100"));
    _codes.add(_CodeData("16", "0", "0", "16", "10011101100"));
    _codes.add(_CodeData("17", "1", "1", "17", "10011100110"));
    _codes.add(_CodeData("18", "2", "2", "18", "11001110010"));
    _codes.add(_CodeData("19", "3", "3", "19", "11001011100"));
    _codes.add(_CodeData("20", "4", "4", "20", "11001001110"));
    _codes.add(_CodeData("21", "5", "5", "21", "11011100100"));
    _codes.add(_CodeData("22", "6", "6", "22", "11001110100"));
    _codes.add(_CodeData("23", "7", "7", "23", "11101101110"));
    _codes.add(_CodeData("24", "8", "8", "24", "11101001100"));
    _codes.add(_CodeData("25", "9", "9", "25", "11100101100"));
    _codes.add(_CodeData("26", ":", ":", "26", "11100100110"));
    _codes.add(_CodeData("27", ";", ";", "27", "11101100100"));
    _codes.add(_CodeData("28", "<", "<", "28", "11100110100"));
    _codes.add(_CodeData("29", "=", "=", "29", "11100110010"));
    _codes.add(_CodeData("30", ">", ">", "30", "11011011000"));
    _codes.add(_CodeData("31", "?", "?", "31", "11011000110"));
    _codes.add(_CodeData("32", "@", "@", "32", "11000110110"));
    _codes.add(_CodeData("33", "A", "A", "33", "10100011000"));
    _codes.add(_CodeData("34", "B", "B", "34", "10001011000"));
    _codes.add(_CodeData("35", "C", "C", "35", "10001000110"));
    _codes.add(_CodeData("36", "D", "D", "36", "10110001000"));
    _codes.add(_CodeData("37", "E", "E", "37", "10001101000"));
    _codes.add(_CodeData("38", "F", "F", "38", "10001100010"));
    _codes.add(_CodeData("39", "G", "G", "39", "11010001000"));
    _codes.add(_CodeData("40", "H", "H", "40", "11000101000"));
    _codes.add(_CodeData("41", "I", "I", "41", "11000100010"));
    _codes.add(_CodeData("42", "J", "J", "42", "10110111000"));
    _codes.add(_CodeData("43", "K", "K", "43", "10110001110"));
    _codes.add(_CodeData("44", "L", "L", "44", "10001101110"));
    _codes.add(_CodeData("45", "M", "M", "45", "10111011000"));
    _codes.add(_CodeData("46", "N", "N", "46", "10111000110"));
    _codes.add(_CodeData("47", "O", "O", "47", "10001110110"));
    _codes.add(_CodeData("48", "P", "P", "48", "11101110110"));
    _codes.add(_CodeData("49", "Q", "Q", "49", "11010001110"));
    _codes.add(_CodeData("50", "R", "R", "50", "11000101110"));
    _codes.add(_CodeData("51", "S", "S", "51", "11011101000"));
    _codes.add(_CodeData("52", "T", "T", "52", "11011100010"));
    _codes.add(_CodeData("53", "U", "U", "53", "11011101110"));
    _codes.add(_CodeData("54", "V", "V", "54", "11101011000"));
    _codes.add(_CodeData("55", "W", "W", "55", "11101000110"));
    _codes.add(_CodeData("56", "X", "X", "56", "11100010110"));
    _codes.add(_CodeData("57", "Y", "Y", "57", "11101101000"));
    _codes.add(_CodeData("58", "Z", "Z", "58", "11101100010"));
    _codes.add(_CodeData("59", "[", "[", "59", "11100011010"));
    _codes.add(_CodeData("60", "\\", "\\", "60", "11101111010"));
    _codes.add(_CodeData("61", "]", "]", "61", "11001000010"));
    _codes.add(_CodeData("62", "^", "^", "62", "11110001010"));
    _codes.add(_CodeData("63", "_", "_", "63", "10100110000"));
    _codes.add(_CodeData("64", "\0", "`", "64", "10100001100"));
    _codes
        .add(_CodeData("65", String.fromCharCode(1), "a", "65", "10010110000"));
    _codes
        .add(_CodeData("66", String.fromCharCode(2), "b", "66", "10010000110"));
    _codes
        .add(_CodeData("67", String.fromCharCode(3), "c", "67", "10000101100"));
    _codes
        .add(_CodeData("68", String.fromCharCode(4), "d", "68", "10000100110"));
    _codes
        .add(_CodeData("69", String.fromCharCode(5), "e", "69", "10110010000"));
    _codes
        .add(_CodeData("70", String.fromCharCode(6), "f", "70", "10110000100"));
    _codes
        .add(_CodeData("71", String.fromCharCode(7), "g", "71", "10011010000"));
    _codes
        .add(_CodeData("72", String.fromCharCode(8), "h", "72", "10011000010"));
    _codes
        .add(_CodeData("73", String.fromCharCode(9), "i", "73", "10000110100"));
    _codes.add(
        _CodeData("74", String.fromCharCode(10), "j", "74", "10000110010"));
    _codes.add(
        _CodeData("75", String.fromCharCode(11), "k", "75", "11000010010"));
    _codes.add(
        _CodeData("76", String.fromCharCode(12), "l", "76", "11001010000"));
    _codes.add(
        _CodeData("77", String.fromCharCode(13), "m", "77", "11110111010"));
    _codes.add(
        _CodeData("78", String.fromCharCode(14), "n", "78", "11000010100"));
    _codes.add(
        _CodeData("79", String.fromCharCode(15), "o", "79", "10001111010"));
    _codes.add(
        _CodeData("80", String.fromCharCode(16), "p", "80", "10100111100"));
    _codes.add(
        _CodeData("81", String.fromCharCode(17), "q", "81", "10010111100"));
    _codes.add(
        _CodeData("82", String.fromCharCode(18), "r", "82", "10010011110"));
    _codes.add(
        _CodeData("83", String.fromCharCode(19), "s", "83", "10111100100"));
    _codes.add(
        _CodeData("84", String.fromCharCode(20), "t", "84", "10011110100"));
    _codes.add(
        _CodeData("85", String.fromCharCode(21), "u", "85", "10011110010"));
    _codes.add(
        _CodeData("86", String.fromCharCode(22), "v", "86", "11110100100"));
    _codes.add(
        _CodeData("87", String.fromCharCode(23), "w", "87", "11110010100"));
    _codes.add(
        _CodeData("88", String.fromCharCode(24), "x", "88", "11110010010"));
    _codes.add(
        _CodeData("89", String.fromCharCode(25), "y", "89", "11011011110"));
    _codes.add(
        _CodeData("90", String.fromCharCode(26), "z", "90", "11011110110"));
    _codes.add(
        _CodeData("91", String.fromCharCode(27), "{", "91", "11110110110"));
    _codes.add(
        _CodeData("92", String.fromCharCode(28), "|", "92", "10101111000"));
    _codes.add(
        _CodeData("93", String.fromCharCode(29), "}", "93", "10100011110"));
    _codes.add(
        _CodeData("94", String.fromCharCode(30), "~", "94", "10001011110"));

    _codes.add(_CodeData("95", String.fromCharCode(31),
        String.fromCharCode(127), "95", "10111101000"));
    _codes.add(_CodeData("96", String.fromCharCode(202) /*FNC3*/,
        String.fromCharCode(202) /*FNC3*/, "96", "10111100010"));
    _codes.add(_CodeData("97", String.fromCharCode(201) /*FNC2*/,
        String.fromCharCode(201) /*FNC2*/, "97", "11110101000"));
    _codes.add(_CodeData("98", "SHIFT", "SHIFT", "98", "11110100010"));
    _codes.add(_CodeData("99", "CODE_C", "CODE_C", "99", "10111011110"));
    _codes.add(_CodeData("100", "CODE_B", String.fromCharCode(203) /*FNC4*/,
        "CODE_B", "10111101110"));
    _codes.add(_CodeData("101", String.fromCharCode(203) /*FNC4*/, "CODE_A",
        "CODE_A", "11101011110"));
    _codes.add(_CodeData(
        "102",
        String.fromCharCode(200) /*FNC1*/,
        String.fromCharCode(200) /*FNC1*/,
        String.fromCharCode(200) /*FNC1*/,
        "11110101110"));
    _codes
        .add(_CodeData("103", "START_A", "START_A", "START_A", "11010000100"));
    _codes
        .add(_CodeData("104", "START_B", "START_B", "START_B", "11010010000"));
    _codes
        .add(_CodeData("105", "START_C", "START_C", "START_C", "11010011100"));
    _codes.add(_CodeData("", "STOP", "STOP", "STOP", "11000111010"));
  }

  List findStartorCodeCharacter(String s, int col) {
    var rows = <_CodeData>[];

    //if two chars are numbers (or FNC1) then START_C or CODE_C
    if (s.length > 1 &&
        (s[0].isNumber() || s[0] == String.fromCharCode(200)) &&
        (s[1].isNumber() || s[1] == String.fromCharCode(200))) {
      if (startCharacter == null) {
        startCharacter = _codes.firstWhere((item) => item!.a == 'START_C');
        rows.add(startCharacter!);
      } else {
        rows.add(_codes.firstWhere((item) => item!.a == 'CODE_C')!);
      }

      col = 1;
    } else {
      var aFound = false;
      var bFound = false;
      for (_CodeData? row in _codes) {
        if (!aFound && s == row!.a) {
          aFound = true;
          col = 2;

          if (startCharacter == null) {
            startCharacter = _codes.firstWhere((item) => item!.a == 'START_A');
            rows.add(startCharacter!);
          } else {
            rows.add(_codes.firstWhere(
                (item) => item!.b == 'CODE_A')!); //first column is FNC4 so use B
          }
        } else if (!bFound && s == row!.b) {
          bFound = true;
          col = 1;

          if (startCharacter == null) {
            startCharacter = _codes.firstWhere((item) => item!.a == 'START_B');
            rows.add(startCharacter!);
          } else
            rows.add(_codes.firstWhere((item) => item!.a == 'CODE_B')!);
        } else if (aFound && bFound) break;
      }

      if (rows.length <= 0)
        throw new Exception("EC128-2: Could not determine start character.");
    }

    return [rows, col];
  }

  String calculateCheckDigit() {
    int checkSum = 0;

    for (int i = 0; i < _formattedData.length; i++) {
      //replace apostrophes with double apostrophes for escape chars
      var s = _formattedData[i].replaceAll("'", "''");

      //try to find value in the A column
      var rows = _codes.firstWhere((item) => item!.a == s, orElse: () => null);

      //try to find value in the B column
      if (rows == null) {
        rows = _codes.firstWhere((item) => item!.b == s, orElse: () => null);
      }

      //try to find value in the C column
      if (rows == null) {
        rows = _codes.firstWhere((item) => item!.c == s, orElse: () => null);
      }

      var value = int.parse(rows!.value);
      var addition = value * ((i == 0) ? 1 : i);
      checkSum += addition;
    }

    int remainder = (checkSum % 103);
    var retRows =
        _codes.firstWhere((item) => item!.value == remainder.toString());

    return retRows!.encoding;
  }

  breakUpDataForEncoding() {
    String temp = "";
    String tempRawData = _data;

    //breaking the raw data up for code A and code B will mess up the encoding
    if (_code128Type == Code128Type.A || _code128Type == Code128Type.B) {
      for (int i = 0; i < _data.length; i++) {
        _formattedData.add(_data[i]);
      }
      return;
    }

    if (_code128Type == Code128Type.C) {
      if (!checkNumericOnly(_data)) {
        throw new Exception(
            "EC128-6: Only numeric values can be encoded with C128-C.");
      }

      //CODE C: adds a 0 to the front of the Data if the length is not divisible by 2
      if (_data.length % 2 > 0) {
        tempRawData = "0" + _data;
      }
    }

    for (int i = 0; i < tempRawData.length; i++) {
        final String c = tempRawData[i];
        if (c.isNumber()) {
          if (temp == "") {
            temp += c;
          } else {
            temp += c;
            _formattedData.add(temp);
            temp = "";
          }
        } else {
          if (temp != "") {
            _formattedData.add(temp);
            temp = "";
          }
          _formattedData.add(c);
        }
    }

    //if something is still in temp go ahead and push it onto the queue
    if (temp != "") {
      _formattedData.add(temp);
      temp = "";
    }
  }

  insertStartandCodeCharacters() {
    _CodeData currentCodeSet;
    var currentCodeString = "";

    if (_code128Type != Code128Type.Auto) {
      switch (_code128Type) {
        case Code128Type.A:
          _formattedData.insert(0, "START_A");
          break;
        case Code128Type.B:
          _formattedData.insert(0, "START_B");
          break;
        case Code128Type.C:
          _formattedData.insert(0, "START_C");
          break;
        default:
          throw new Exception(
              "EC128-4: Unknown start type in fixed type encoding.");
      }
    } else {
      try {
        for (var i = 0; i < (_formattedData.length); i++) {
          var col = 0;
          var result = findStartorCodeCharacter(_formattedData[i], col);
          List<_CodeData> tempStartChars = result[0];
          col = result[1];
          //check all the start characters and see if we need to stay with the same codeset or if a change of sets is required
          var sameCodeSet = false;
          for (var row in tempStartChars) {
            if (row.a.endsWith(currentCodeString) ||
                row.b.endsWith(currentCodeString) ||
                row.c.endsWith(currentCodeString)) {
              sameCodeSet = true;
              break;
            }
          }

          if (currentCodeString == "" || !sameCodeSet) {
            currentCodeSet = tempStartChars[0];
            var error = true;

            while (error) {
              try {
                currentCodeString = currentCodeSet.getValue(col).split('_')[1];
                error = false;
              } catch (_) {
                error = true;

                if (col++ > 5)
                  throw new Exception(
                      "No start character found in CurrentCodeSet.");
              }
            }

            _formattedData.insert(i++, currentCodeSet.getValue(col));
          }
        }
      } catch (ex) {
        throw Exception("EC128-3: Could not insert start and code characters.");
      }
    }
  }

  String encode() {
    //break up data for encoding
    breakUpDataForEncoding();

    //insert the start characters
    insertStartandCodeCharacters();

    var encodedData = "";
    for (var s in _formattedData) {
      //handle exception with apostrophes in select statements
      var s1 = s.replaceAll("'", "''");
      List<_CodeData?> eRow = [];

      //select encoding only for type selected
      switch (_code128Type) {
        case Code128Type.A:
          eRow = _codes.where((item) => item!.a == s1).toList();
          break;
        case Code128Type.B:
          eRow = _codes.where((item) => item!.b == s1).toList();
          break;
        case Code128Type.C:
          eRow = _codes.where((item) => item!.c == s1).toList();
          break;
        case Code128Type.Auto:
          eRow = _codes.where((item) => item!.a == s1).toList();
          if (eRow.length <= 0) {
            eRow = _codes.where((item) => item!.b == s1).toList();

            if (eRow.length <= 0) {
              eRow = _codes.where((item) => item!.c == s1).toList();
            }
          }
          break;
      }

      if (eRow.length <= 0)
        throw new Exception("EC128-5: Could not find encoding of a value( " +
            s1 +
            " ) in C128 type " +
            _code128Type.toString());

      encodedData += eRow[0]!.encoding;
      _encodedData.add(eRow[0]!.encoding);
    }

    //add the check digit
    encodedData += calculateCheckDigit();
    _encodedData.add(calculateCheckDigit());

    //add the stop character
    encodedData += _codes.firstWhere((item) => item!.a == 'STOP')!.encoding;
    _encodedData.add(_codes.firstWhere((item) => item!.a == 'STOP')!.encoding);

    //add the termination bars
    encodedData += "11";
    _encodedData.add("11");

    return encodedData;
  }

  bool checkNumericOnly(String? data) {
    //This function takes a string of data and breaks it into parts and trys to do Int64.TryParse
    //This will verify that only numeric data is contained in the string passed in.  The complexity below
    //was done to ensure that the minimum number of interations and checks could be performed.

    //early check to see if the whole number can be parsed to improve efficency of this method

    if (data != null) {
      if (int.tryParse(data) != null) return true;
    } else {
      return false;
    }

    //9223372036854775808 is the largest number a 64bit number(signed) can hold so ... make sure its less than that by one place
    const int stringLengths = 18;

    var temp = data;
    var list = List<String>.filled((data.length ~/ stringLengths) +
        ((data.length % stringLengths == 0) ? 0 : 1), '');
    var strings = list;

    var i = 0;

    while (i < strings.length) {
      if (temp.length >= stringLengths) {
        strings[i++] = temp.substring(0, stringLengths);
        temp = temp.substring(stringLengths);
      } else {
        strings[i++] = temp.substring(0);
      }
    }

    return !strings.any((s) => int.tryParse(s) == null);
  }
}
