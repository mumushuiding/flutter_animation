// ResponseData 用于接收从后台返回的数据
class ResponseData{
  TBody body;
  THeader header;
  ResponseData(){
    body = TBody();
    header = THeader();
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["body"] = this.body.toJson();
    data["header"]=this.header.toJson();
    return data;
  }

  ResponseData.fromJson(Map<String, dynamic> json){
    body = TBody.fromJson(json["body"]);
    header = THeader.fromJson(json["header"]);
  }
  static List<dynamic>  fromResponse(Map<String,dynamic> data){
    if (data["status"]!=200){
      print("err:${data["message"]}");
      return null;
    }
    ResponseData rd=ResponseData.fromJson(data["message"]);
    return rd.body.data;
  }

  // static List<T>  fromResponse<T>(Map<String,dynamic> data){
  //   if (data["status"]!=200){
  //     print("err:${data["message"]}");
  //     return null;
  //   }
  //   List<T> result=List();
  //   ResponseData rd=ResponseData.fromJson(data["message"]);
  //   rd.body.data[0].forEach((d){
  //     result.add(T.fromJson(d));
  //   });
  //   return result;

  // }
}
class TBody{
  int total;
  int startIndex;
  int maxResults;
  String startDate;
  String endDate;
  String method;
  String userName;
  String metrics;
  var data;
  TBody();
  TBody.fromJson(Map<String, dynamic> json){
    if (json==null) return;
    total = json['total'];
    startIndex = json['start_index'];
    maxResults = json['max_results'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    method = json['method'];
    userName = json['username'];
    metrics = json['metrics'];
    data = json["data"];
    
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = Map();
    data["total"] = this.total;
    data["start_index"] = this.startIndex;
    data["max_results"] = this.maxResults;
    data["start_date"] = this.startDate;
    data["end_date"] = this.endDate;
    data["method"] = this.method;
    data["data"] = this.data;
    data["username"] = this.userName;
    data["metrics"] = this.metrics;
    return data;
  }
}

class THeader{
  String token;
  String msg;
  THeader();
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = Map();
    data["token"]=this.token;
    data["msg"]=this.msg;
    return data;
  }
  THeader.fromJson(Map<String,dynamic> json){
    if (json==null) return;
    token=json["token"];
    msg=json["msg"];
  }
}