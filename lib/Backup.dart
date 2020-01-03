/*
 * Copyright 2019 mybytecode
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_blog/utils/CheckInternetConnection.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_blog/future/ArticleByCategoryId.dart';
import 'package:flutter_blog/future/Categories.dart';
import 'package:flutter_blog/Screens/DisplayArticle.dart';
import 'package:flutter_blog/utils/Utils.dart';
import 'package:flutter_blog/widgets/ArticleListPreLoader.dart';

// ignore: must_be_immutable
class NewsLoader extends StatefulWidget {
  var categoryName;

  NewsLoader(this.categoryName);

  @override
  State<StatefulWidget> createState() => NewsList(categoryName);
}

class NewsList extends State<NewsLoader>
    with AutomaticKeepAliveClientMixin<NewsLoader> {
  var categoryName;

  NewsList(this.categoryName);

  bool networkState = true;

  @override
  void initState() {
    super.initState();
    CheckInternetState().check().then((value) {
      networkState = value;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetNewsByCategoryName(categoryName, "").getNews(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: ArticleListPreLoader(),
              ),
            );
          } else if (!networkState) {
            return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/images/nointernet.png'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Not connected to internet",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ));
          } else {
            return CustomScrollView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                _buildNewsSlider(context, snapshot),
                _newsList(context, snapshot)
              ],
            );
          }
        });
  }

  //*****************Cards at the top****************//
  SliverToBoxAdapter _buildNewsSlider(
      BuildContext context, AsyncSnapshot snapshot) {
    return SliverToBoxAdapter(
        child: Container(
      height: 180,
      child: Swiper(
        onTap: (int index) {
          onItemTap(snapshot, index);
        },
        physics: ScrollPhysics(),
        itemCount: 2,
        autoplay: true,
        curve: Curves.easeInBack,
        itemBuilder: (BuildContext context, int index) {
          return Stack(children: <Widget>[
            Container(
              height: 190,
              width: double.infinity,
              child: Image.network(
                  snapshot.data[index].embedded.media[0].sourceLink,
                  fit: BoxFit.fill),
            ),
            Container(
              height: 190,
              color: Colors.black.withOpacity(0.4),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Text(
                Utils().parseHTML(snapshot.data[index].title.rendered),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 1,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                Utils().parseHTML(snapshot.data[index].excerpt.rendered),
                softWrap: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 1,
              ),
            )
          ]);
        },
      ),
    ));
  }

  //****************News List************
  SliverList _newsList(BuildContext context, AsyncSnapshot snapshot) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return ListTile(
        onTap: () {
          onItemTap(snapshot, index);
        },
        leading: Image.network(
          snapshot.data[index].embedded.media[0].sourceLink,
          width: 100,
          height: 120,
        ),
        title: Text(
          Utils().parseHTML(snapshot.data[index].title.rendered),
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(top: 5, left: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text(
                Utils().dateParse(snapshot.data[index].date),
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 5),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Utils().getRandomColor(),
                  borderRadius: BorderRadius.circular(10)),
              child: FutureBuilder(
                future: GetCategoriesById(snapshot.data[index].categories[0])
                    .getCategories(),
                builder: (BuildContext context, AsyncSnapshot snapshotC) {
                  if (snapshotC.data == null) {
                    return Text("India",
                        style: TextStyle(color: Colors.white, fontSize: 10));
                  } else {
                    return Text(
                      snapshotC.data,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }, childCount: snapshot.data.length));
  }

  @override
  bool get wantKeepAlive => true;

  onItemTap(AsyncSnapshot snapshot, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayArticle(
                Utils().parseHTML(snapshot.data[index].title.rendered),
                snapshot.data[index].embedded.media[0].sourceLink,
                snapshot.data[index].categories[0],
                snapshot.data[index].date,
                snapshot.data[index].link,
                snapshot.data[index].content.rendered,
                snapshot.data[index].id)));
  }
}
