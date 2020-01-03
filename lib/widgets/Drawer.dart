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
import 'package:flutter/widgets.dart';
import 'package:flutter_blog/Screens/ArticlesListByCategoryHolder.dart';
import 'package:flutter_blog/Screens/FavouriteArticleList.dart';
import 'package:flutter_blog/Screens/OfflineArticlesList.dart';
import 'package:flutter_blog/future/Categories.dart';
import 'package:flutter_blog/widgets/AppTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ArticleListPreLoader.dart';

class DrawerBar {
  Widget drawerBar(BuildContext mContext) {
    return Drawer(
        child: Scaffold(
      body: FutureBuilder(
        future: GetCategories().getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: ArticleListPreLoader(),
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: DefaultTheme.defaultColor),
                  child: Center(
                    child: (Image.asset('assets/images/logo.png')),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: DefaultTheme.iconColor,
                  ),
                  title: Text(
                    "Favourite Articles",
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouriteArticleList()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.solidBookmark,
                    color: DefaultTheme.iconColor,
                  ),
                  title: Text("Saved Offline"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfflineArticles()));
                  },
                ),
                Divider(),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticlesByCategoryHolder(
                                      snapshot.data[index].id,
                                      snapshot.data[index].name)));
                        },
                        leading: Icon(
                          FontAwesomeIcons.link,
                          color: DefaultTheme.iconColor,
                        ),
                        title:
                            Container(child: Text(snapshot.data[index].name)),
                      );
                    }),
                Divider(),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: DefaultTheme.iconColor,
                  ),
                  title: Text(
                    "About Us",
                  ),
                ),
                Divider()
              ],
            );
          }
        },
      ),
    ));
  }
}
