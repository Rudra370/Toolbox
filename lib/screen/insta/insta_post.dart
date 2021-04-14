import 'package:better_player/better_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/model/Insta_model.dart';
import 'package:toolbox/screen/widget/floating_download.dart';

class InstaPost extends StatefulWidget {
  final InstaMedia media;
  final String fullName;

  const InstaPost({@required this.media, @required this.fullName});
  @override
  _InstaPostState createState() => _InstaPostState();
}

class _InstaPostState extends State<InstaPost> {
  InstaMedia media;
  String fullName;

  @override
  void initState() {
    media = widget.media;
    fullName = widget.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(fullName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (media.typeName == 'GraphImage')
                Image.network(
                  media.displayUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                  },
                  fit: BoxFit.fill,
                ),
              if (media.isVideo)
                BetterPlayer.network(
                  media.videoUrl,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    autoPlay: true,
                    fit: BoxFit.contain,
                    aspectRatio: 1,
                    looping: true,
                    showPlaceholderUntilPlay: true,
                    showControlsOnInitialize: false,
                  ),
                ),
              if (media.typeName == 'GraphSidecar')
                CarouselSlider.builder(
                  itemCount: media.instaMediaSide.length,
                  itemBuilder: (context, index) {
                    if (media.instaMediaSide[index].isVideo) {
                      return BetterPlayer.network(
                        media.instaMediaSide[index].videoUrl,
                        betterPlayerConfiguration: BetterPlayerConfiguration(
                          autoPlay: true,
                          fit: BoxFit.contain,
                          aspectRatio: 1,
                          looping: true,
                          showPlaceholderUntilPlay: true,
                          showControlsOnInitialize: false,
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        child: Image.network(
                            media.instaMediaSide[index].displayUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            ),
                          );
                        }, frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            child: child,
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                          );
                        }),
                      );
                    }
                  },
                  options: CarouselOptions(
                    aspectRatio: 1,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                  ),
                ),
              if (media.caption != null)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    media.caption,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              if (media.caption == null)
                SizedBox(
                  height: 15,
                ),
              if (media.isVideo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.remove_red_eye,
                        size: 22,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(media.videoViews,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18))
                    ],
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite_outline,
                      size: 22,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(media.likes,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18))
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.comment_outlined,
                      size: 22,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(media.comment,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        floatingActionButton: MyFloatingButton(media: media));
  }
}
