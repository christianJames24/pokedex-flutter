// Source - https://stackoverflow.com/a
// Posted by Hannah Stark, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-29, License - CC BY-SA 4.0

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalize2() {
    if (isEmpty) return this;

    return replaceAllMapped(
      RegExp(r'(^|[\s-])([a-zA-Z])'),
      (match) => '${match.group(1)}${match.group(2)!.toUpperCase()}',
    );
  }
}
