class Media {
  final String? artistName;
  final String? artworkUrl;
  final String? collectionName;
  final String? trackName;
  final String? previewUrl;

  Media({this.artistName,
         this.artworkUrl,
         this.collectionName,
         this.trackName,
         this.previewUrl});

  factory Media.fromJson(Map<String, dynamic> tagJson) {
    return Media(
      artistName: tagJson['artistName'] as String?,
      artworkUrl: tagJson['artworkUrl100'] as String?,
      collectionName: tagJson['collectionName'] as String?,
      trackName: tagJson['trackName'] as String?,
      previewUrl: tagJson['previewUrl'] as String?,
    );
  }
}
