extension StringExtension on String {
  isNumber() {
    if (this.isEmpty) {
      return false;
    }
    return double.tryParse(this) != null;
  }
}