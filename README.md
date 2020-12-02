# flutter_echart

A new Flutter package.

## Getting Started

* 可关注公众号：我的大前端生涯   获取最新技术分享
* [可关注网易云课堂：](https://study.163.com/instructor/1021406098.htm)
* [可关注博客：](https://blog.csdn.net/zl18603543572)
* [西瓜视频 ](https://www.ixigua.com/home/3662978423)
* [知乎]( https://www.zhihu.com/people/zhao-long-90-89)


>在码农的世界里，优美的应用体验，来源于程序员对细节的处理以及自我要求的境界，年轻人也是忙忙碌碌的码农中一员，每天、每周，都会留下一些脚印，就是这些创作的内容，有一种执着，就是不知为什么，如果你迷茫，不妨来瞅瞅码农的轨迹。

* [优美的音乐节奏带你浏览这个效果的编码过程](https://www.zhihu.com/zvideo/1313903176165351424)
* [坚持每一天，是每个有理想青年的追求](https://www.ixigua.com/6900018293596226059/)
*  [追寻年轻人的脚步，也许你的答案就在这里](https://www.bilibili.com/video/BV1Nt4y1v7mc/)

***

#### 1 简介
flutter_echart  是基于Flutter Canvas 绘图思想实现的图表功能，支持饼状图、柱状图、拆线图，在2020-12-02 更新1.0.1版本，将动态饼状图发布到[ pub 仓库](https://pub.flutter-io.cn/packages/flutter_echart)，地址如下：

```java
https://pub.flutter-io.cn/packages/flutter_echart
```
大家可以直接在 Flutter 项目中添加依赖如下：

```java
dependencies:
  flutter_echart: ^1.0.0
```
然后加载一下依赖

```java
flutter pub get
```
然后在使用的地方导包如下：

```java
import 'package:flutter_echart/flutter_echart.dart';
```

#### 1 饼状图

首先需要有饼图数据，flutter_echart提供了EChartPieBean对象来封装数据。

##### 1.1 EChartPieBean的定义

```java
class EChartPieBean {
  //用户自定义的数据
  dynamic id;
  //直线上显示的文案
  String title;
  //当前数值占用的比例
  int number;
  //当前饼状的颜色
  Color color;
  //内部使用
  bool isClick;

  EChartPieBean(
      {this.id,
      this.title = '',
      this.number = 100,
      this.color = Colors.blue,
      this.isClick = false});
}

```
##### 1.2 饼图基本使用
首先定义数据
```java
  List<EChartPieBean> _dataList = [
    EChartPieBean(title: "生活费", number: 200, color: Colors.lightBlueAccent),
    EChartPieBean(title: "游玩费", number: 200, color: Colors.deepOrangeAccent),
    EChartPieBean(title: "交通费", number: 400, color: Colors.green),
    EChartPieBean(title: "贷款费", number: 300, color: Colors.amber),
    EChartPieBean(title: "电话费", number: 200, color: Colors.orange),
  ];
```

如下图所示，以动画的方式显示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020120301091229.gif#pic_center)
对应代码如下：

```java
  PieChatWidget buildPieChatWidget() {
    return PieChatWidget(
      dataList: _dataList,
      //是否输出日志
      isLog: true,
      //是否需要背景
      isBackground: true,
      //是否画直线
      isLineText: true,
      //背景
      bgColor: Colors.white,
      //是否显示最前面的内容
      isFrontgText: true,
      //默认选择放大的块
      initSelect: 1,
      //初次显示以动画方式展开
      openType: OpenType.ANI,
      //旋转类型
      loopType: LoopType.DOWN_LOOP,
      //点击回调
      clickCallBack: (int value) {
        print("当前点击显示 $value");
      },
    );
  }
```
initSelect 属性为默认选择放大显示的饼块，当此值为 -2 时，不会有放大效果

当 isBackground 属性为 false时，效果如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203011418822.gif#pic_center)
当 isLineText 为false 时 ：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203011520679.gif#pic_center)
当 isFrontgText 为false 时：

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020120301223448.gif#pic_center)
##### 1.3 饼图交互

使用 属性 loopType 来配置：

```java
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

```

取值为 LoopType.NON 无任何交互
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203013109466.gif#pic_center)
取值为 LoopType.DOWN 点击放大，如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203013159900.gif#pic_center)
取值为 LoopType.MOVE  手指在饼图触点范围内就会放大，如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203013240265.gif#pic_center)
取值为 LoopType.DOWN_LOOP  手指按下可旋转，如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203013321308.gif#pic_center)


取值为 LoopType.AUTO_LOOP 自动循环旋转，手指按下停止旋转：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201203013120622.gif#pic_center)



不局限于思维，不局限语言限制，才是编程的最高境界。

以小编的性格，肯定是要录制一套视频的，随后会上传

 有兴趣 你可以关注一下  [西瓜视频 --- 早起的年轻人](https://www.toutiao.com/c/user/token/MS4wLjABAAAAYMrKikomuQJ4d-cPaeBqtAK2cQY697Pv9xIyyDhtwIM/)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201031094959816.gif#pic_center)

