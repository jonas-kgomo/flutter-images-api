import 'dart:async';
import 'dart:convert';
//import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'keys.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {


  // String token = '6fbb61876dcfbf4a3b9a84563d4afcf6090f757922b7ebccb5fb5da85f1210f6';


  final response =
      await client.get(
        'https://picsum.photos/v2/list'
       // 'https://jsonplaceholder.typicode.com/photos'
        //'https://api.unsplash.com/photos',
        // headers: { 'Authorization': 'Bearer $token', }
    );
        
    // Check that the request was successful.


  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}





List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
//  final int albumId;
//  final int id;
  final String title;
  final String url;
//  List<Link> link;
//  final String thumbnailUrl;

  Photo({ this.title, this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
    //  albumId: json['id'] as int,
    //  id: json['id'] as int,
      title: json['author'] as String,
      url: json['download_url'] as String,
  //    thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Image API Search';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // 2 for bi-sectional 
      ),
      itemCount: photos.length,
      
      itemBuilder: (context, index) {
        return new Card (
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          elevation: 5.0,
    
          //child: Image.network(photos[index].url, filterQuality: FilterQuality.low, fit: BoxFit.cover, height: 100, ), // scale: 0.5,  filterQuality: FilterQuality.low
          child: new Container(
         
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                        //  color: Color(0xffD50000),
                          width: 3,
                        ),),
                          child: new Column(
                            children: <Widget>[
                              Column(
                                  children: <Widget>[
                                    Image.network(photos[index].url, fit: BoxFit.contain, alignment: Alignment.center),
                                    Text(photos[index].title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal) ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                    );  },
    );
  }
}