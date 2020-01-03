import 'package:flutter_blog/constants/Constants.dart';
import 'package:http/http.dart'as http;
class PostComment
{
  Future<String> postComment(String content,String post) async
  {
    String url =Config.gBaseUrl+"/wp-json/wp/v2/comments";
    print(url);
    var response = await http.post(url,
    body: {
      'author_email':"mybytecode@gmail.com",
      'author_name':"Akshay Galande",
      'content':content,
      'post':post
    });

    return response.body;
  }
}