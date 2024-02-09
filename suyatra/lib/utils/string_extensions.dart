
extension StringExtension on String {
  String capitalize() {
    if(isEmpty){
      return "";
    } else {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
  }

  String initials() {
    if (isNotEmpty) {
      var output = this[0];
      return output;
    } else {
      return "\$";
    }
  }
}


