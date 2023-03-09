import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class RepoScreen extends StatefulWidget {
  var arg = Get.arguments;

  @override
  State<RepoScreen> createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  // const RepoScreen({super.key});

  List<dynamic> commitList = [];

  Future<void> fetchCommits() async {
    try {
      var url = widget.arg;

      url = url.substring(0, url.length - 6);

      final parsedUrl = Uri.parse(url);

      final response = await http.get(parsedUrl);

      final data = json.decode(response.body);
      print(data);
      setState(() {
        commitList = data;
      });
      // print(repoList);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text("Last Commits"),
        ),
        body: FutureBuilder(
          future: fetchCommits(),
          builder: ((context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: commitList.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              height: 160,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              width: MediaQuery.of(context).size.width - 20,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                      "Author: ${commitList[index]['commit']['author']['name']}"),
                                  Text(
                                      "Email : ${commitList[index]['commit']['author']['email']}"),
                                  Text(
                                      "Date : ${commitList[index]['commit']['author']['date']}"),
                                  Text(
                                      "Message : ${commitList[index]['commit']['message']}",
                                      overflow: TextOverflow.ellipsis),
                                  Container(
                                    height: 40,
                                    width: 150,
                                    child: TextButton(
                                        onPressed: (() async {
                                          await FlutterWebBrowser.openWebPage(
                                              url: (commitList[index]
                                                  ['html_url']));
                                        }),
                                        child: Text("View in browser")),
                                  )
                                ],
                              ),
                            );
                          })),
                    ),
                  );
          }),
        ));
  }
}
