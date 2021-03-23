

import 'dart:html';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpRequest {
  final client;
  HttpRequest(this.client);
  Future<dynamic> post(String uri, dynamic body,{Map<String, String> headers}) async {
    try {
      http.Response response = await client.post(uri,body:body);
      var result = jsonDecode(response.body);
      return result;
    } catch (e) {
      // print('[uri=$uri] exception e=$e');
      return null;
    }
  }
  Future<dynamic> get(String uri) async{
    try{
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      }
    }catch(e){
      // print('[uri=$uri] exception e=$e');
      return null;
    }
  }
   Future<void> download(String uri, dynamic body,{Map<String, String> headers}) async{
    //  headers=Map();
    //  headers["Content-Type"]="application/octet-stream";
    // //  headers["Content-Disposition"]="attachment;filename=export.csv";
     http.Response response= await client.post(uri,body:body);
     Element elink=document.createElement("a");
     elink.setAttribute("download","export.csv");
     elink.style.display='none';
     var uris=Uri.dataFromBytes(response.bodyBytes);
     elink.setAttribute("href",uris.toString());
     document.body.append(elink);
     elink.click();
     elink.remove();
   }
}