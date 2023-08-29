class Tag {
  Tag({
    required this.tagId,
    required this.tagName,
    required this.tagDescription,
  });

  final int tagId;
  final String tagName;
  final String tagDescription;

  /// A factory method that creates a [Tag] object from a [Map] of [String] keys
  /// and [dynamic] values. 
  /// 
  /// The [json] variable is a [Map] of [String] keys and [dynamic] values that
  /// represents the JSON data returned from the backend.
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_id'],
      tagName: json['tag_name'],
      tagDescription: json['tag_description'],
    );
  }
}
