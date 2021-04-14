import 'package:flutter/material.dart';
import 'package:toolbox/screen/insta/insta_link.dart';
import 'package:toolbox/screen/youtube/youtube_link.dart';

class Home extends StatelessWidget {
  final pages = [
    {'page': YoutubeLink(), 'name': 'Youtube', 'color': Colors.red[700]},
    {'page': InstaLink(), 'name': 'Instagram', 'color': Colors.blue[700]},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toolbox'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView.builder(
          reverse: true,
          itemCount: pages.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => pages[index]['page'],
                ),
              ),
              child: Card(
                color: pages[index]['color'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.39,
                  child: Center(
                      child: Text(
                    pages[index]['name'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
