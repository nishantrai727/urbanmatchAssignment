import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // const DashboardScreen({super.key});
  List<dynamic> repoList = [];

  @override
  void initState() {
    // ignore: unnecessary_null_comparison
    fetchList();
    super.initState();
  }

  Future<void> fetchList() async {
    try {
      final url = "https://api.github.com/users/freeCodeCamp/repos";
      final parsedUrl = Uri.parse(url);

      final response = await http.get(parsedUrl);

      final data = json.decode(response.body);
      // print(data);
      setState(() {
        repoList = data;
      });
      print(repoList);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage("github-mark.png"))),
          ),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          title: Text("DASHBOARD"),
        ),
        body: FutureBuilder(
            future: fetchList(),
            builder: ((context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: repoList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 100,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {},
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      repoList[index]['owner']
                                                          ['avatar_url']))),
                                        ),
                                        title: Text(repoList[index]['name']),
                                      ),
                                      Container(
                                        height: 30,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: () {
                                              Get.toNamed("/repoScreen",
                                                  arguments: repoList[index]
                                                      ['commits_url']);
                                            },
                                            child: Text("View last commits")),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    );
            })));
  }
}
