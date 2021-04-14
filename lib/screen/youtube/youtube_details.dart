import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/model/youtube_model.dart';

class YoutubeDetails extends StatefulWidget {
  final res;
  YoutubeDetails({@required this.res});
  @override
  _YoutubeDetailsState createState() => _YoutubeDetailsState();
}

class _YoutubeDetailsState extends State<YoutubeDetails> {
  var audioDownloading = false;
  var audioProgress = 0.0;

  void _downloadAudio(String link, String title, BuildContext ctx) async {
    final url = link;
    await Permission.storage.request();
    setState(() {
      audioDownloading = true;
    });
    final storageInfo = await PathProviderEx.getStorageInfo();
    print('download started');
    try {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'You can minimize the app\nAudio will be downloaded in Internal storage/toolbox/youtube/audio/')));
      await Dio().download(
        url,
        '${storageInfo[0].rootDir}/toolbox/youtube/audio/$title.mp3',
        onReceiveProgress: (count, total) {
          var progress = (count / total) * 100;
          setState(() {
            audioProgress = progress;
          });
        },
      );
      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content:
              Text('Downloaded in Internal storage/toolbox/youtube/audio/')));
    } on SocketException catch (_) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('No Internet'),
      ));
    } on Exception catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Error code : $e'),
      ));
      print(e);
    }
    setState(() {
      audioProgress = 0.0;
      audioDownloading = false;
    });
    print('Download complete');
  }

  var videoDownloading = false;
  var videoProgress = 0.0;

  void _downloadVideo(String link, String title, BuildContext ctx) async {
    final url = link;
    await Permission.storage.request();
    setState(() {
      videoDownloading = true;
    });
    final storageInfo = await PathProviderEx.getStorageInfo();
    print('download started');
    try {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'You can minimize the app\nVideo will be downloaded in Internal storage/toolbox/youtube/video/')));
      await Dio().download(
        url,
        '${storageInfo[0].rootDir}/toolbox/youtube/video/$title.mp4',
        onReceiveProgress: (count, total) {
          var progress = (count / total) * 100;
          setState(() {
            videoProgress = progress;
          });
        },
      );
      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content:
              Text('Downloaded in Internal storage/toolbox/youtube/video/')));
    } on SocketException catch (_) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('No Internet'),
        ),
      );
    } on Exception catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Error code : $e'),
      ));
    }
    setState(() {
      videoProgress = 0.0;
      videoDownloading = false;
    });
    print('Download complete');
  }

  var thumbDownloading = false;
  var thumbProgress = 0.0;

  void _downloadThumb(String link, String title, BuildContext ctx) async {
    final url = link;
    await Permission.storage.request();
    setState(() {
      thumbDownloading = true;
    });
    final storageInfo = await PathProviderEx.getStorageInfo();
    print('download started');
    try {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'You can minimize the app\nThumbnail will be downloaded in Internal storage/toolbox/youtube/thumbnail/')));
      await Dio().download(
        url,
        '${storageInfo[0].rootDir}/toolbox/youtube/thumbnail/$title.jpg',
        onReceiveProgress: (count, total) {
          var progress = (count / total) * 100;
          setState(() {
            thumbProgress = progress;
          });
        },
      );
      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'Downloaded in Internal storage/toolbox/youtube/thumbnail/')));
    } on SocketException catch (_) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text('No Internet'),
        ),
      );
    } on Exception catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Error code : $e'),
      ));
    }
    setState(() {
      thumbProgress = 0.0;
      thumbDownloading = false;
    });
    print('Download complete');
  }

  @override
  Widget build(BuildContext context) {
    Youtube data = Youtube.fromJson(widget.res);
    final audio = data.url.firstWhere((item) {
      return (item.ext == 'm4a');
    });
    final video = data.url[0];
    final title = data.meta.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Download'),
      ),
      body: Builder(
        builder: (ctx) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.network(
                    data.thumb,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 15,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () => _downloadThumb(data.thumb, title, ctx),
                      child: thumbDownloading
                          ? Text('${thumbProgress.toStringAsFixed(0)} %')
                          : Icon(
                              Icons.download_sharp,
                              color: Colors.black,
                            ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Duration ${data.meta.duration}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () =>
                              _downloadAudio(audio.url, title, ctx),
                          child: Row(
                            children: [
                              audioDownloading
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      height: 25,
                                      width: 25,
                                    )
                                  : Icon(
                                      Icons.download_sharp,
                                      color: Colors.white,
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                audioDownloading
                                    ? '${audioProgress.toStringAsFixed(0)} %'
                                    : 'Audio',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () =>
                              _downloadVideo(video.url, title, ctx),
                          child: Row(
                            children: [
                              videoDownloading
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      height: 25,
                                      width: 25,
                                    )
                                  : Icon(
                                      Icons.download_sharp,
                                      color: Colors.white,
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                videoDownloading
                                    ? '${videoProgress.toStringAsFixed(0)} %'
                                    : 'Video',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (data.meta.tags.isNotEmpty)
                      Text(
                        'Tags :',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    if (data.meta.tags.isNotEmpty)
                      SizedBox(
                        height: 10,
                      ),
                    if (data.meta.tags.isNotEmpty)
                      SelectableText(
                        data.meta.tags,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
