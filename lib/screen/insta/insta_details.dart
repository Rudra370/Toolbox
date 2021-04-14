import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolbox/model/Insta_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toolbox/screen/insta/insta_post.dart';

class InstaDetails extends StatefulWidget {
  final Insta user;

  const InstaDetails({@required this.user});

  @override
  _InstaDetailsState createState() => _InstaDetailsState();
}

class _InstaDetailsState extends State<InstaDetails> {
  var _hasNextPage;
  var _endcursor;
  List<InstaMedia> media;
  Insta user;
  var _isLoading = true;
  @override
  void initState() {
    media = widget.user.instaMedia;
    user = widget.user;
    _hasNextPage = user.hasNextPage;
    _endcursor = user.endCursor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    var _id = user.id;
    Future<void> _loadMore() async {
      print('Loading');
      if (_hasNextPage) {
        final prefs = await SharedPreferences.getInstance();
        final session = prefs.getString('sessionid');
        final url =
            '''https://www.instagram.com/graphql/query/?query_hash=56a7068fea504063273cc2120ffd54f3&variables={"id":"$_id","first":12,"after":"$_endcursor"}''';
        final response = await http.get(url,
            headers: {'Host': 'instagram.com', 'Cookie': 'sessionid=$session'});
        Insta _media =
            Insta.fromJson(json.decode(response.body)['data']['user']);
        _endcursor = _media.endCursor;
        _hasNextPage = _media.hasNextPage;
        _media.instaMedia.forEach((data) {
          media.add(data);
        });
        setState(() {});
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }

    void _download(BuildContext ctx) async {
      await Permission.storage.request();
      final storageInfo = await PathProviderEx.getStorageInfo();
      print('download started');
      try {
        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(
                'You can minimize the app\nAudio will be downloaded in Internal storage/toolbox/insta/dp/')));
        await Dio().download(
          user.profilePicUrl,
          '${storageInfo[0].rootDir}/toolbox/insta/dp/${user.fullName}.png',
        );
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text('Downloaded in Internal storage/toolbox/insta/dp/')));
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
      print('Download complete');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePicUrl),
                  radius: deviceWidth * 0.25,
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => _download(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Text>[
                    Text(
                      'Posts',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.05),
                    ),
                    Text(
                      user.posts,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: deviceWidth * 0.05),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Text>[
                    Text(
                      'Followers',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.05),
                    ),
                    Text(
                      user.follower,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: deviceWidth * 0.05),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Text>[
                    Text(
                      'Following',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.05),
                    ),
                    Text(
                      user.following,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: deviceWidth * 0.05),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: LazyLoadScrollView(
                onEndOfPage: () {
                  _loadMore();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: media.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) => Container(
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InstaPost(
                                  media: media[index],
                                  fullName: user.fullName,
                                ),
                              )),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(media[index].thumbnail),
                                  if (media[index].typeName == 'GraphVideo')
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 35,
                                        color: Colors.blueGrey[50],
                                      ),
                                    ),
                                  if (media[index].typeName == 'GraphSidecar')
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Icon(
                                        Icons.crop_square_rounded,
                                        size: 35,
                                        color: Colors.blueGrey[50],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
