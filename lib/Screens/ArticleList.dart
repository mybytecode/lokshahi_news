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
import 'package:flutter_blog/Models/NewsModesl.dart';
import 'package:flutter_blog/Screens/DisplayArticle.dart';
import 'package:flutter_blog/future/ArticleByCategoryId.dart';
import 'package:flutter_blog/utils/CheckInternetConnection.dart';
import 'package:flutter_blog/utils/ImageLoader.dart';
import 'package:flutter_blog/utils/Utils.dart';
import 'package:flutter_blog/widgets/ArticleListPreLoader.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
  var pageNumber = 1;
  List<NewsModel> articleList;
  ScrollController _scrollController = ScrollController();

  //constructor
  NewsList(this.categoryName);

  bool networkState = true;

  @override
  void initState() {
    super.initState();
    CheckInternetState().check().then((value) {
      networkState = value;
    });

    //fetch news
    GetNewsByCategoryName(categoryName, pageNumber).getNews().then((value) {
      setState(() {
        articleList = value;
        pageNumber++;
      });
    });

    //observe the listview scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("I reached bottom");
        getMoreData();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (articleList == null) {
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ));
    } else {
      return ListView(
        controller: _scrollController,
        children: <Widget>[
          _buildNewsSlider(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: (Text(
                  "Latest News",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
          Divider(),
          newList(context),
          //_newsList(context, snapshot)
        ],
      );
    }
  }

//*****************Cards at the top****************//
  Widget _buildNewsSlider(BuildContext context) {
    return Container(
      height: 180,
      child: Swiper(
        onTap: (int index) {
          onItemTap(index);
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
                  articleList[index].embedded.media[0].sourceLink,
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
                Utils().parseHTML(articleList[index].title.rendered),
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
                Utils().parseHTML(articleList[index].excerpt.rendered),
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
    );
  }

  Widget newList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == articleList.length) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
          ));
        }
        return ListTile(
          onTap: () {
            onItemTap(index);
          },
          onLongPress: () {
            showArticlePreview(context, index);
          },
          leading: ImageLoader().articleListImage(
              100.0, 120.0, articleList[index].embedded.media[0].sourceLink),
          title: Text(
            Utils().parseHTML(articleList[index].title.rendered),
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
                  Utils().dateParse(articleList[index].date),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        );
      },
      physics: ScrollPhysics(),
      itemCount: articleList == null ? 1 : articleList.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  onItemTap(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayArticle(
                Utils().parseHTML(articleList[index].title.rendered),
                articleList[index].embedded.media[0].sourceLink,
                articleList[index].categories[0],
                articleList[index].date,
                articleList[index].link,
                articleList[index].content.rendered,
                articleList[index].id)));
  }

  void showArticlePreview(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: ImageLoader().articleListImage(200.0, 200.0,
                        articleList[index].embedded.media[0].sourceLink),
                  ),
                  Container(
                    child: Text(
                      Utils().parseHTML(articleList[index].title.rendered),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      Utils().parseHTML(articleList[index].content.rendered),
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  void getMoreData() {
    GetNewsByCategoryName(categoryName, pageNumber).getNews().then((value) {
      pageNumber++;
      articleList.addAll(value);
      setState(() {});
      print(articleList.length);
    });
  }
}
/*Container(
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
              ),*/
