import 'package:requests/requests.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/model/Insta_model.dart';
import 'package:toolbox/screen/insta/insta_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstaReview extends StatefulWidget {
  final Insta data;
  InstaReview({@required this.data});
  @override
  _InstaReviewState createState() => _InstaReviewState();
}

class _InstaReviewState extends State<InstaReview> {
  var dpDownloading = false;
  var dpProgress = 0.0;

  void _downloadDP(String link, String title, BuildContext ctx) async {
    final url = link;
    await Permission.storage.request();
    setState(() {
      dpDownloading = true;
    });
    final storageInfo = await PathProviderEx.getStorageInfo();
    print('download started');
    try {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'You can minimize the app\nImage will be downloaded in Internal storage/toolbox/insta/profile pic/')));
      await Dio().download(
        url,
        '${storageInfo[0].rootDir}/toolbox/insta/profile pic/$title.png',
        onReceiveProgress: (count, total) {
          var progress = (count / total) * 100;
          setState(() {
            dpProgress = progress;
          });
        },
      );
      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              'Downloaded in Internal storage/toolbox/insta/profile pic/')));
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
      dpProgress = 0.0;
      dpDownloading = false;
    });
    print('Download complete');
  }

  
  @override
  Widget build(BuildContext context) {
    Insta user = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName),
      ),
      body: Builder(
        builder: (ctx) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicUrl),
                    radius: 70,
                  ),
                  if (user.isVerified)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 30,
                      ),
                    )
                ],
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
                        _downloadDP(user.profilePicUrl, user.fullName, ctx),
                    child: Row(
                      children: [
                        dpDownloading
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                          dpDownloading
                              ? '${dpProgress.toStringAsFixed(0)} %'
                              : 'DP',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      color: Colors.black,
                      onPressed: () async {
                        if (user.posts.length > 0 &&
                            user.instaMedia.length == 0) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${user.fullName} has private account and you might had not followed the user.'),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InstaDetails(
                            user: user,
                          ),
                        ));
                      },
                      child: Text(
                        'See Profile',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
