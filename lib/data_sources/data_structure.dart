part of rare_print;

class DataStructure {
  Map<String, dynamic>? templateData;
  List<DataStructureField> fileds = [];

  DataStructure.parseJson(Map<String, dynamic> data, [String path = "data."]) {
    this.templateData = data;
    fileds = [];
    for (var key in data.keys) {
      fileds.add(DataStructureField.parseJson(key, data[key], path + key));
    }
  }

  DataStructure.fromJson(Map<String, dynamic> data) {
    List filedsJson = data['fileds'];
    this.fileds = filedsJson.map((json) => DataStructureField.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};

    for (var item in fileds) {
      result[item.name!] = item.toJson();
    }

    return result;
  }
}

class DataStructureField {
  String? name;
  int? type;
  DataStructure? refStructure;
  int listLevel = 0; // 列表层次
  String? path;

  DataStructureField.parseJson(String name, dynamic value, String path) {
    this.name = name;
    this.path = path;
    while(value is List) {
      this.listLevel++;
      if (value.length > 0) {
        value = value[0];
      } else {
        value = null;
      }
    }
    if (value is int || value is double) {
      type = DataTypeEnum.Num;
    } else if (value is String) {
      if (DateTime.tryParse(value) != null) {
        type = DataTypeEnum.DateTime;
      } else {
        type = DataTypeEnum.String;
      }
    } else if (value is Map<String, dynamic>) {
      type = DataTypeEnum.Structure;
      refStructure = DataStructure.parseJson(value, path + "." + name + ".");
    } else if (value is bool) {
      type = DataTypeEnum.Bool;
    }
  }

  DataStructureField.fromJson(Map<String, dynamic>  json) {
    this.name = json['name'];
    this.type = json['type'];
    this.listLevel = json['listLevel'];
    this.path = json['path'];
    
    this.refStructure = json['refStructure'] != null ? DataStructure.fromJson(json['refStructure']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};

    result['name'] = name;
    result['type'] = type;
    result['listLevel'] = listLevel;
    result['path'] = path;
    result['refStructure'] = refStructure?.toJson();

    return result;
  }
}

class DataTypeEnum {
  static const int Num = 1;
  static const int String = 2;
  static const int DateTime = 3;
  static const int Bool = 4;
  static const int Structure = 9;
}
