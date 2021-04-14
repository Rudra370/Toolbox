import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/model/Insta_model.dart';

class MyFloatingButton extends StatefulWidget {
  final InstaMedia media;

  const MyFloatingButton({@required this.media});
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  InstaMedia media;
  @override
  void initState() {
    media = widget.media;
    super.initState();
  }

  var downloading = false;

  void _download(BuildContext ctx) async {
    setState(() {
      downloading = true;
    });
    await Permission.storage.request();
    setState(() {
      downloading = true;
    });
    final storageInfo = await PathProviderEx.getStorageInfo();
    print('download started');
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
            'You can minimize the app\nPost will be downloaded in Internal storage/toolbox/insta/post/'),
      ),
    );
    try {
      if (media.typeName == 'GraphImage') {
        await Dio().download(
          media.displayUrl,
          '${storageInfo[0].rootDir}/toolbox/insta/post/${media.id}.png',
        );
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Downloaded in Internal storage/toolbox/insta/post/'),
          ),
        );
      }
      if (media.isVideo) {
        await Dio().download(
          media.videoUrl,
          '${storageInfo[0].rootDir}/toolbox/insta/post/${media.id}.mp4',
        );
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Downloaded in Internal storage/toolbox/insta/post/'),
          ),
        );
      }

      if (media.typeName == 'GraphSidecar') {
        for (int i = 0; i < media.instaMediaSide.length; i++) {
          final url = media.instaMediaSide[i].isVideo
              ? media.instaMediaSide[i].videoUrl
              : media.instaMediaSide[i].displayUrl;
          await Dio().download(
            url,
            media.instaMediaSide[i].isVideo
                ? '${storageInfo[0].rootDir}/toolbox/insta/post/${media.id + (i + 1).toString()}.mp4'
                : '${storageInfo[0].rootDir}/toolbox/insta/post/${media.id + (i + 1).toString()}.png',
          );
        }
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text('Downloaded in Internal storage/toolbox/insta/post/'),
        ));
      }
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
      downloading = false;
    });
    print('Download complete');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      child: downloading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 3,
              ),
            )
          : Icon(
              Icons.download_sharp,
              color: Colors.white,
            ),
      onPressed: () => _download(context),
    );
  }
}
