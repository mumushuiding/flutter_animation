import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'routes.dart';

class FluroRouter{
  final router = Router();
  static Map<String,dynamic> routerMap;
  FluroRouter(){
    this.defineRoutes(router);
  }
  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    String routeName = settings.name;
    // String routeName="/yxkh/dashboard?token=FrHdJrg5NMRRfQugkXzTmJetKWebATwrcL9jfua2dFq2";
    var uri=Uri.dataFromString(routeName);
    // print("onGenerateRoute path:$routeName,params:${uri.queryParametersAll}");
    var parmas=uri.queryParametersAll;
    if (parmas!=null&&parmas["token"].length>0){
      App.getUserByToken(token: parmas["token"][0]);
    }
    RouteHandler route=Routes.getRoute(routeName);
    if (route==null){
      print("找不到路径$routeName");
      return null;
    }
    // 判断权限
    if(!Routes.checkAuthority(route)){
      print("访问 ${route.route}} 需要权限:${route.meta.authority}");
      return null;
    }
    
    return MaterialPageRoute(builder: (context){
      return route.handler(params:parmas);
    });
  }
  void navigateTo(BuildContext context,String path){
    print("navigateTo path:$path");
    // 判断路径是否存在
    var rh=Routes.getRoute(path);
    if (rh==null) {
      App.showAlertError(context,"路径不存在,跳转失败");
      return;
    }
    // 判断权限
    if(!Routes.checkAuthority(rh)){
      App.showAlertError(context,"访问 $path 需要权限:${rh.meta.authority}");
      return;
    }
    router.navigateTo(context, path);
  }
  void defineRoutes(Router router){
    // 初始化路由
    print("初始化路由");
    Routes.getRouters().forEach((r){
      router.define(
        r.route,handler: Handler(handlerFunc: (BuildContext context,Map<String,dynamic> params){
          return r.handler(params:params);
        })
      );
    });
  }
}
