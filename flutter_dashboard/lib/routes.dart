import 'package:flutter/material.dart';
import './pages/dashboard.dart';

import 'app.dart';
import 'pages/page_404.dart';

class Routes {

  // YxkhDashboard 一线考核操作页面
  static const String YxkhDashboard='/yxkhDashboard';
static const String Error='/404';
  static List<RouteHandler> routers;

  // 获取路由，可用于main.dart中的路由注册，这样就可以直接通过url访问
  static Map<String,Widget Function(BuildContext)> getNeedsRoutesRegistry(BuildContext context){
    
    return routers.where(needsRoutesRegistry).toList().asMap().map((k,v)=>MapEntry<String,Widget Function(BuildContext)>(v.route,(context)=>v.handler()));

  }
  static List<RouteHandler> getRouters(){
    return routers;
  }
    // 需要显示在底部菜单栏的项
  static  List<RouteHandler> getNeedsBottomNavRegistry(){
    // print('底部菜单栏');
    var result=routers.where(needsBottomNavRegistry).toList();
    return result;
  }
  static bool needsDrawerRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsDrawerRegistry;
  }
  // 需要显示在侧边栏
  static List<RouteHandler> getNeedsDrawerRegistry(){
    // print('侧边栏：${routers[0].title}');
    var result=routers.where((r)=>needsDrawerRegistry(r)).toList();
    return result;
  }
  // 可以搜索的功能
  static List<RouteHandler> getSearchRegistry(){
    var result=routers.where(needsRoutesRegistry).toList();
    return result;
  }
  static bool needsRoutesRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsRoutesRegistry;
  }
  static bool needsBottomNavRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsBottomRegistry;
  }

  // 获取路由
  static RouteHandler getRoute(String path){
    if (path==null) return null;
    var route=path.split("?")[0];
    return routers.singleWhere((r)=>r.route==route);
  }
  // 检查权限
  static bool checkAuthority(RouteHandler routeHandler){
    // 勿须验证
    if (routeHandler.meta==null||routeHandler.meta.authority==null) {
      // print("无需验证");
      return true;
    }
    // 用户无权限
    var labels=App.userinfos.labels;
    if (labels==null||labels.length==0) {
      // print('用户标签为空');
      return false;
    }
    // 用户权限不匹配
    return routeHandler.meta.authority.indexWhere((a){
      return labels.indexWhere((l)=>l.labelname==a)>-1;
    })>-1;    
  }
  static void setRouters(){
    routers=<RouteHandler>[
      RouteHandler(title: "日常一线考核",icon:Icons.work,handler: ({Map<String,dynamic> params})=>DashboardWidget(params: params,),route: Routes.YxkhDashboard,
        meta: RouteMeta(needsDrawerRegistry: false)
      ),
      RouteHandler(title: "错误页面",icon:Icons.work,handler: ({Map<String,dynamic> params})=>ErrorPageWidget(),route: Routes.Error,
        meta: RouteMeta(needsDrawerRegistry: true)
      ),
  ];
  }
}

class RouteHandler {

 Function({Map<String,dynamic> params}) handler;
 String route;
 IconData icon; 
 String title;
 RouteMeta meta;
 RouteHandler({this.handler,this.icon,this.title,this.route,this.meta});
}
class RouteMeta{
  // 是否在drawer中显示
  bool needsDrawerRegistry;
  // 是否在底部菜单栏显示
  bool needsBottomRegistry;
  // 是否需要路由注册，这样就可以直接通过url访问
  bool needsRoutesRegistry;
  // 需要访问权限
  List<String> authority;
  RouteMeta({this.needsDrawerRegistry=false,this.needsBottomRegistry=false,this.needsRoutesRegistry=false,this.authority});
}
