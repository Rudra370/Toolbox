class Insta {
  String biography;
  String email;
  String externalUrl;
  String follower;
  String following;
  String fullName;
  String id;
  bool isPrivate = false;
  bool isVerified = false;
  String profilePicUrl;
  String userName;
  String posts;
  bool hasNextPage = false;
  String endCursor;
  List<InstaMedia> instaMedia;
  Insta({
    this.biography,
    this.email,
    this.externalUrl,
    this.follower,
    this.following,
    this.fullName,
    this.id,
    this.isPrivate,
    this.isVerified,
    this.profilePicUrl,
    this.userName,
    this.posts,
    this.hasNextPage,
    this.endCursor,
    this.instaMedia,
  });
  Insta.fromJson(Map<String, dynamic> json) {
    biography = json.containsKey('biography') ? json['biography'] : null;
    email = json.containsKey('business_email') ? json['business_email'] : null;
    externalUrl =
        json.containsKey('external_url') ? json['external_url'] : null;
    follower = json.containsKey('edge_followed_by')
        ? json['edge_followed_by']['count'].toString()
        : null;
    following = json.containsKey('edge_follow')
        ? json['edge_follow']['count'].toString()
        : null;
    fullName = json.containsKey('full_name') ? json['full_name'] : null;
    id = json.containsKey('id') ? json['id'] : null;
    isPrivate = json.containsKey('is_private') ? json['is_private'] : false;
    isVerified = json.containsKey('is_verified') ? json['is_verified'] : false;
    profilePicUrl = json.containsKey('profile_pic_url_hd')
        ? json['profile_pic_url_hd']
        : null;
    userName = json.containsKey('username') ? json['username'] : null;
    posts = json.containsKey('edge_owner_to_timeline_media')
        ? json['edge_owner_to_timeline_media']['count'].toString()
        : null;
    hasNextPage = json.containsKey('edge_owner_to_timeline_media')
        ? json['edge_owner_to_timeline_media']['page_info']['has_next_page']
        : false;
    endCursor = json.containsKey('edge_owner_to_timeline_media')
        ? json['edge_owner_to_timeline_media']['page_info']['end_cursor']
        : null;
    List<dynamic> edge = json['edge_owner_to_timeline_media']['edges'];
    instaMedia = new List<InstaMedia>();
    edge.forEach((data) {
      instaMedia.add(new InstaMedia.fromJson(data['node']));
    });
  }
}

class InstaMedia {
  String typeName;
  String id;
  String displayUrl;
  bool isVideo = false;
  String videoUrl;
  String videoViews;
  String caption;
  String comment;
  String likes;
  String thumbnail;
  List<InstaMediaSide> instaMediaSide;
  InstaMedia(
      {this.typeName,
      this.id,
      this.displayUrl,
      this.isVideo,
      this.videoUrl,
      this.videoViews,
      this.caption,
      this.comment,
      this.likes,
      this.thumbnail,
      this.instaMediaSide});

  InstaMedia.fromJson(Map<String, dynamic> json) {
    typeName = json['__typename'];
    id = json['id'];
    displayUrl = json['display_url'];
    isVideo = json['is_video'];
    videoUrl = json.containsKey('video_url') ? json['video_url'] : null;
    videoViews = json.containsKey('video_view_count')
        ? json['video_view_count'].toString()
        : null;
    List<dynamic> _caption = json['edge_media_to_caption']['edges'];
    caption = _caption.length > 0 ? _caption[0]['node']['text'] : null;
    comment = json.containsKey('edge_media_to_comment')
        ? json['edge_media_to_comment']['count'].toString()
        : json['edge_media_preview_comment']['count'].toString();
    likes = json['edge_media_preview_like']['count'].toString();
    thumbnail =
        json.containsKey('thumbnail_src') ? json['thumbnail_src'] : null;
    if (typeName == 'GraphSidecar') {
      List<dynamic> edge = json['edge_sidecar_to_children']['edges'];
      instaMediaSide = new List<InstaMediaSide>();
      edge.forEach((data) {
        instaMediaSide.add(new InstaMediaSide.fromJson(data['node']));
      });
    }
  }
}

class InstaMediaSide {
  String typeName;
  String displayUrl;
  bool isVideo = false;
  String videoUrl;
  InstaMediaSide({
    this.typeName,
    this.displayUrl,
    this.isVideo,
    this.videoUrl,
  });
  InstaMediaSide.fromJson(Map<String, dynamic> json) {
    typeName = json['__typename'];
    displayUrl = json['display_url'];
    isVideo = json['is_video'];
    videoUrl = json.containsKey('video_url') ? json['video_url'] : null;
  }
}
