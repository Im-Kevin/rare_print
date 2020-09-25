part of rare_print;

abstract class DataSourceBase {
  final evaluator = CustomExpressionEvaluator();
  Map<String, dynamic> get dataSource;

  dynamic execExpressionToValue(String expressionStr) {
    try {
      var expression = Expression.parse(expressionStr);
      Map<String, dynamic> context = {
        'now': () => DateTime.now(),
        'isEmpty': _isEmpty,
        'isNotEmpty': (value) => !_isEmpty(value),
        'fd': fd,
        'sum': sum,
        'toString': toStringFunc,
        'safeAdd': safeAdd,
        'safeSub': safeSub,
        'safeMul': safeMul,
        'safeDiv': safeDiv
      };
      context.addAll(dataSource);
      return evaluator.eval(expression, context);
    } catch (_) {
      return null;
    }
  }
  // List<DataSourceBase> execExpressionToList(String expression);

  String? execExpressionToString(String expressionStr, String? format) {
    if (format == '') {
      format = null;
    }
    try {
      var value = execExpressionToValue(expressionStr);
      DateTime? date;
      if (value == null) {
        return null;
      }
      if (value is String) {
        date = DateTime.tryParse(value);
      }
      if (value is num) {
        var numberFormat = new NumberFormat(format ?? '#################.##');
        return numberFormat.format(value);
      } else if (value is DateTime) {
        var dateFormat = new DateFormat(format ?? 'yyyy-MM-dd HH:mm');
        return dateFormat.format(value);
      } else if (date != null) {
        var dateFormat = new DateFormat(format ?? 'yyyy-MM-dd HH:mm');
        return dateFormat.format(date);
      } else if (value is String) {
        if (format == null) {
          return value;
        } else {
          return format.replaceAll('{0}', value);
        }
      } else {
        return format;
      }
    } catch (_) {
      return null;
    }
  }

  String fd(dynamic number) {
    var numberFormat = new NumberFormat('#################.##');
    return numberFormat.format(number);
  }

  dynamic sum(List data, String name) {
    if (data.isNotEmpty) {
      Decimal result = Decimal.zero;
      for (int i = 0; i < data.length; i++) {
        if (data[i] is List) {
          result += Decimal.parse(sum(data[i], name).toString());
        } else {
          result += Decimal.parse(data[i][name].toString());
        }
      }
      return result.toDouble();
    } else {
      return null;
    }
  }

  String toStringFunc(dynamic value) {
    return value.toString();
  }

  double safeAdd(dynamic p1, dynamic p2) {
    Decimal d1 = Decimal.parse(p1.toString());
    Decimal d2 = Decimal.parse(p2.toString());
    return (d1 + d2).toDouble();
  }

  double safeSub(dynamic p1, dynamic p2) {
    Decimal d1 = Decimal.parse(p1.toString());
    Decimal d2 = Decimal.parse(p2.toString());
    return (d1 - d2).toDouble();
  }

  double safeMul(dynamic p1, dynamic p2) {
    Decimal d1 = Decimal.parse(p1.toString());
    Decimal d2 = Decimal.parse(p2.toString());
    return (d1 * d2).toDouble();
  }

  double safeDiv(dynamic p1, dynamic p2) {
    Decimal d1 = Decimal.parse(p1.toString());
    Decimal d2 = Decimal.parse(p2.toString());
    return (d1 * d2).toDouble();
  }
}

class DataSource extends DataSourceBase {
  @override
  Map<String, dynamic> dataSource;
  DataSource(data):
  this.dataSource = {
      'data': data,
    };
}

class RowDataSource extends DataSourceBase {
  @override
  Map<String, dynamic> dataSource;

  RowDataSource(
      Map<String, dynamic> data, DataSourceBase parent, int rowIndex)
      :this.dataSource = {
      'data': data,
      '\$parent\$': parent.dataSource,
      '\$rowIndex\$': rowIndex
    };
}

class CustomExpressionEvaluator extends ExpressionEvaluator {
  @override
  dynamic evalMemberExpression(
      MemberExpression expression, Map<String, dynamic> context) {
    var data = eval(expression.object, context);
    if (data is Map) {
      return data[expression.property.name];
    } else if (data is List && data.isNotEmpty && data.first is Map) {
      if (expression.property.name.startsWith(r'$$')) {
        var fieldName = expression.property.name.substring(2);
        return data
            .map((e) => e[fieldName])
            .toList();
      } else {
        return data[0][expression.property.name];
      }
    } else if (data is List && data.isNotEmpty && data.first is List && data.first.isNotEmpty && data.first.first is Map) 
    {
      if (expression.property.name.startsWith(r'$$')) {
        var result = [];
        var fieldName = expression.property.name.substring(2);
        for (var item in data) {
          result.addAll(item
            .map((e) => e[fieldName]));
        }
        return result;
      } else {
        return data[0][expression.property.name];
      }
    }
    else {
      throw UnsupportedError('Member expressions only supported Map');
    }
  }
}

_isEmpty(value) {
  if (value == null) {
    return true;
  }
  if (value == '') {
    return true;
  }
  if (value == 0) {
    return true;
  }
  return false;
}
