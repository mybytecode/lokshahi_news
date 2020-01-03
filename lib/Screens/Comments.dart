import 'package:flutter/material.dart';
import 'package:flutter_blog/future/CommentByArticle.dart';
import 'package:flutter_blog/future/PostComment.dart';
import 'package:flutter_blog/widgets/ArticleListPreLoader.dart';
import 'package:flutter_html/flutter_html.dart';

class Comment extends StatefulWidget {
  final int articleId;

  Comment(this.articleId);

  @override
  State<StatefulWidget> createState() => CommentsState(articleId);
}

class CommentsState extends State<Comment> {
  int articleId;
  TextEditingController _controller = TextEditingController();

  CommentsState(this.articleId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: CommentByArticle().getComment(articleId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: ArticleListPreLoader(),
              );
            } else if (snapshot.data.length == 0) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 35, left: 10),
                            child: Text(
                              "Comments",
                              style: TextStyle(
                                  fontSize: 20,
                                  //color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )),
                        Divider(),
                        Container(
                            padding: EdgeInsets.only(top: 20, left: 10),
                            child: Column(
                              children: <Widget>[
                                /*Image.asset('assets/images/comment.png'),*/
                                Icon(Icons.comment,size: 300,),
                                Text(
                                  "No comments yet..",
                                  style: TextStyle(
                                      /*color: Colors.black54, */fontSize: 20),
                                ),
                                Text(
                                  "Be the first one to comment",
                                  style: TextStyle(
                                      /*color: Colors.black54*/),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  _buildBottomBar(context)
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 35, left: 10),
                            child: Text(
                              "Comments",
                              style: TextStyle(
                                  fontSize: 20,
                                  /*color: Colors.black54,*/
                                  fontWeight: FontWeight.bold),
                            )),
                        Divider(),
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(snapshot
                                          .data[index].author_avatar_urls.s48),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xffF0EFEF)),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    snapshot.data[index]
                                                        .author_name,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: 250,
                                                  child: Html(
                                                    data: snapshot.data[index]
                                                        .content.rendered,
                                                  ),
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  _buildBottomBar(context)
                ],
              );
            }
          }),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Write comment"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.blueAccent,
            onPressed: () {
              postComment(context);
            },
          )
        ],
      ),
    );
  }

  void postComment(BuildContext context) async {
    String response =
        await PostComment().postComment(_controller.text, articleId.toString());
    print(response);
  }
}
