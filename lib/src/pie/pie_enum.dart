import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/12/2.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
/// 图类型
enum ChartType {
  PIE,//饼图
  LINE,//拆线
  BAR,//柱状图
}

//打开方式
enum OpenType {
  ANI,//动画
  NON,//什么也没有
}

//饼图交互
enum LoopType {
  //无交互
  NON,
  //按下时放大
  DOWN,
  //按下移动放大
  MOVE,
  //按下旋转
  DOWN_LOOP,
  //自动旋转
  AUTO_LOOP,
}
