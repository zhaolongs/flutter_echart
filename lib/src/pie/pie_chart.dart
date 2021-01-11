import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_echart/src/e_data.dart';
import 'package:flutter_echart/src/pie/pie_enum.dart';

import '../e_chart_bean.dart';
import '../e_log.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/12/2.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///

class EChatWidget extends StatelessWidget {
  final ChartType chartType;

  EChatWidget({Key key, this.chartType = ChartType.PIE}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChatWidget();
  }
}

class PieChatWidget extends StatefulWidget {
  //打开方式
  final OpenType openType;
  final LoopType loopType;
  final List<EChartPieBean> dataList;

  //动画执行时间
  final int animationMills;
  final bool isLog;
  final bool isHelperLine;
  final Color bgColor;
  final int initSelect;

  //是否显示直线
  final bool isLineText;

  //是否显示背景
  final bool isBackground;

  //是否显示前景文案
  final bool isFrontgText;

  final Function(int index) clickCallBack;

  PieChatWidget({
    Key key,
    @required this.dataList,
    this.initSelect = 0,
    this.clickCallBack,
    this.loopType = LoopType.NON,
    this.openType = OpenType.ANI,
    this.isLineText = true,
    this.isBackground = true,
    this.isFrontgText = true,
    this.animationMills = 1800,
    this.isLog = false,
    this.bgColor = const Color(0xFFCADCED),
    this.isHelperLine = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PieChatState();
  }
}

class _PieChatState extends State<PieChatWidget> with TickerProviderStateMixin {
  //来个动画控制器
  AnimationController _animationController;
  AnimationController _lineAnimationController;
  AnimationController _loopAnimationController;

  //控制背景抬高使用的
  Animation<double> _bgAnimation;

  //控制饼图使用的
  Animation<double> _progressAnimation;

  //控制数字使用的
  Animation<double> _numberAnimation;

  List<EChartPieBean> _dataList;

  int initSelect;

  @override
  void initState() {
    super.initState();

    initSelect = widget.initSelect;

    if (widget.dataList == null) {
      _dataList = defaultList;
    } else {
      _dataList = widget.dataList;
    }
    PieLogUtils.isLog = widget.isLog;
    //初始化一下
    _animationController = new AnimationController(
        //执行时间为 1 秒
        duration: Duration(milliseconds: widget.animationMills),
        vsync: this);

    _lineAnimationController = new AnimationController(
        //执行时间为 1 秒
        duration: Duration(milliseconds: 1000),
        vsync: this);

    _loopAnimationController = new AnimationController(
        //执行时间为 1 秒
        duration: Duration(milliseconds: widget.animationMills),
        vsync: this);

    double bgStart = 0.0;
    double bgEend = 0.5;

    double pieStart = 0.4;
    double pieEend = 0.7;
    if (!widget.isBackground) {
      //背景不显示
      pieStart = 0.0;
    }
    if (!widget.isFrontgText) {
      //前景文本不显示
      pieEend = 1.0;
    }
    double frontStart = 0.7;
    double frontEend = 1.0;

    //在 0~500毫秒内 执行背景阴影抬高的操作
    _bgAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(bgStart, bgEend, curve: Curves.bounceOut),
      ),
    );

    //在 400 ~ 800 毫秒的区间内执行画饼的操作动画
    _progressAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(pieStart, pieEend, curve: Curves.bounceOut),
      ),
    );

    //在 700 ~ 1000 毫秒的区间 执行最上层的数字抬高的操作动画
    _numberAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        //执行时间 区间
        curve: Interval(frontStart, frontEend, curve: Curves.bounceOut),
      ),
    );

    //添加 一个监听 刷新页面
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _lineAnimationController.reset();
        _lineAnimationController.forward();
      }
    });
    _lineAnimationController.addListener(() {
      setState(() {});
    });
    _lineAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.loopType == LoopType.AUTO_LOOP) {
          _loopAnimationController.repeat();
        }
      }
    });
    _loopAnimationController.addListener(() {
      setState(() {
        golbalStart += 0.01;
      });
    });

    if (widget.openType == OpenType.ANI) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PieLogUtils.logPrint("开始执行动画");
        _animationController.forward();
      });
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _loopAnimationController.dispose();
    _lineAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //设置一下背景
      color: widget.bgColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: buildStack(),
    );
  }

  double _downX = 0.0;
  double _downY = 0.0;
  bool _isMove = false;
  bool _isDown = false;
  bool _isUpdate = false;

  Stack buildStack() {

    Widget mainItemWidget = Container();
    if(widget.loopType==LoopType.NON){
      mainItemWidget = buildCustomPaint();
    }else{
      mainItemWidget =buildGestureDetector();
    }


    return Stack(
//子 Widget 居中
      alignment: Alignment.center,
      children: [
//第一层
        Container(
//来个内边距
//来个边框装饰
          decoration: widget.isBackground
              ? BoxDecoration(color: widget.bgColor, shape: BoxShape.circle,
//来个阴影
                  boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: -8 * _bgAnimation.value,
                        offset: Offset(
                            -5 * _bgAnimation.value, -5 * _bgAnimation.value),
                        blurRadius: 30 * _bgAnimation.value,
                      ),
                      BoxShadow(
                        //模糊颜色
                        color: Colors.blue[300].withOpacity(0.3),
                        //模糊半径
                        spreadRadius: 2 * _bgAnimation.value,
                        //阴影偏移量
                        offset: Offset(
                            5 * _bgAnimation.value, 5 * _bgAnimation.value),
                        //模糊度
                        blurRadius: 20 * _bgAnimation.value,
                      ),
                    ])
              : null,
          //开始绘制神操作
          child: mainItemWidget,
        ),
        //第二层
        buildFrontTextContainer(),
      ],
    );
  }

  GestureDetector buildGestureDetector() {
    return GestureDetector(
          onTapDown: (TapDownDetails details) {
            initSelect = -1;
            _isDown = true;
            _loopAnimationController.stop();
            setState(() {
              ///相对于父组件的位置
              Offset localPosition = details.localPosition;
              _downY = localPosition.dy;
              _downX = localPosition.dx;
              _isMove = false;
              // print("onTapDown $_downX");
              setState(() {});
            });
          },
          onPanStart: (DragStartDetails details) {
            Offset localPosition = details.localPosition;
            double y = localPosition.dy;
            double x = localPosition.dx;

            print("onPanStart $_downX");
          },
          onPanUpdate: (DragUpdateDetails details) {
            Offset localPosition = details.localPosition;
            double dx = localPosition.dx;
            double dy = localPosition.dy;

            if (widget.loopType == LoopType.DOWN_LOOP) {
              _downY = dy;
              _downX = dx;

              _isMove = true;
              setState(() {});
            } else if (widget.loopType == LoopType.AUTO_LOOP ||
                widget.loopType == LoopType.MOVE) {
              _downY = dy;
              _downX = dx;
              _isMove = false;
              setState(() {});
            }
          },
          onTapUp: (TapUpDetails details) {
            _isUpdate = true;
            Offset localPosition = details.localPosition;
            if (widget.loopType == LoopType.AUTO_LOOP) {
              _loopAnimationController.repeat();
            }
            _isDown = false;
          },
          onPanCancel: () {
            if (widget.loopType == LoopType.AUTO_LOOP) {
              _loopAnimationController.repeat();
            }
          },
          onPanEnd: (DragEndDetails details) {
            if (widget.loopType == LoopType.AUTO_LOOP) {
              _loopAnimationController.repeat();
            }
          },
          child: buildCustomPaint(),
        );
  }

  CustomPaint buildCustomPaint() {
    return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: CustomShapPainter(
              _dataList,
              initSelect: initSelect,
              pieProgress: _progressAnimation.value,
              lineProgress: _lineAnimationController.value,
              downX: _downX,
              downY: _downY,
              loopType: widget.loopType,
              startRadin: golbalStart,
              isDrawLine: widget.isLineText,
              isDrawHelper: widget.isHelperLine,
              isMove: _isMove,
              clickCallBack: (int value) {
                currentSelect = value;
                PieLogUtils.logPrint("点击回调 $value");

                SchedulerBinding.instance
                    .addPostFrameCallback((Duration timeStamp) {
                  PieLogUtils.logPrint("刷新 $_isUpdate");
                  if (widget.isFrontgText && _isUpdate) {
                    _isUpdate = false;
                    setState(() {});
                  }
                  if (widget.clickCallBack != null && _isUpdate) {
                    widget.clickCallBack(value);
                  }
                });
              },
            ),
          );
  }

  Container buildFrontTextContainer() {
    if (!widget.isFrontgText) {
      return Container();
    }
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: widget.bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              spreadRadius: 3 * _numberAnimation.value,
              blurRadius: 5 * _numberAnimation.value,
              offset: Offset(
                  5 * _numberAnimation.value, 5 * _numberAnimation.value),
              color: Colors.black54),
        ],
      ),
      child: Center(
        child: Text(
          "${_dataList[currentSelect].title}",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }

  int currentSelect = 0;
}

//你可以将这些类封装成不同的类文件 在这里小编为提供 Demo 的方便所以写在一起了
double golbalStart = 0.0;

class CustomShapPainter extends CustomPainter {
//数据内容
  List<EChartPieBean> list;

  Function(int index) clickCallBack;
  double pieProgress;
  double lineProgress;
  bool isDrawLine;
  bool isDrawHelper;
  LoopType loopType;
  int initSelect;

  CustomShapPainter(this.list,
      {this.pieProgress,
      this.lineProgress,
      this.initSelect = -1,
      this.downX = 0.0,
      this.downY = 0.0,
      this.loopType = LoopType.DOWN,
      this.isMove,
      this.startRadin = 0.0,
      this.isDrawLine = true,
      this.isDrawHelper = false,
      this.clickCallBack,
      this.isLog = false});

//来个画笔
  Paint _paint = new Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = 2.0;

  TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  double downX;
  double downY;
  bool isLog;

  bool isMove;
  double radius;
  double line1 = 0.0;
  double line2 = 0.0;
  double startRadin = 0.0;
  int currentSelect = 0;

//圆周率（Pi）是圆的周长与直径的比值，一般用希腊字母π表示
//绘制内容
  @override
  void paint(Canvas canvas, Size size) {
//计算半径
    if (size.width > size.height) {
      radius = size.height / 3;
    } else {
      radius = size.width / 3;
    }

    if (lineProgress > 0.1) {
      line1 = radius / 3;
      line2 = radius * lineProgress;
    }
    //将原点移动到画布中心
    canvas.translate(size.width / 2, size.height / 2);
    //合对当前手指按下的点
    downY -= size.height / 2;
    downX -= size.width / 2;
    PieLogUtils.logPrint("手指按下的位置 downX $downX downY $downY");
    var calculatorDegree2 = atan2(downY, downX);
    if (downY < 0) {
      // print("downY $downY downX $downX  calculatorDegree2 $calculatorDegree2");
      calculatorDegree2 = 2 * pi - calculatorDegree2.abs();
    } else {
      // print("downY $downY downX $downX  calculatorDegree2 $calculatorDegree2");
    }

    PieLogUtils.logPrint("手指按下的位置距离开始的角度");

    // 设置起始角度

    double total = 0.0;
    list.forEach((element) {
      total += element.number;
    });

    if (loopType == LoopType.DOWN_LOOP || loopType == LoopType.AUTO_LOOP) {
      if (isMove) {
        startRadin = atan2(downY, downX);
        print("移动中 $startRadin");
      }
    }

    golbalStart = startRadin;

    calculatorDegree2 -= golbalStart;

    if (calculatorDegree2 >= (2 * pi)) {
      print("太大了 calculatorDegree2 $calculatorDegree2");
      calculatorDegree2 = calculatorDegree2 - 2 * pi;
      print("太大了 calculatorDegree2 $calculatorDegree2");
    }

    if (calculatorDegree2 < 0) {
      calculatorDegree2 = 2 * pi - calculatorDegree2.abs();
    }
    // print("_startRadin $startRadin");

    for (var i = 0; i < list.length; i++) {
      var entity = list[i];
      _paint.color = entity.color;

      //计算所占的比例
      double flag = entity.number / total;

      //计算弧度
      double sweepRadin = flag * 2 * pi * pieProgress;

      //计算百分比
      double unitNumber = entity.number/total;

      double endRadin = startRadin + sweepRadin;

      double tagRadius = radius;

      if(initSelect!=-2) {
        if (initSelect == -1 &&
            !isMove &&
            calculatorDegree2 > (startRadin - golbalStart) &&
            calculatorDegree2 <= (endRadin - golbalStart)) {
          tagRadius += 10;
          currentSelect = i;
        } else {
          if (i == initSelect) {
            tagRadius += 10;
            currentSelect = i;
          }
        }
      }

      PieLogUtils.logPrint(
          "绘制 calculatorDegree2 $calculatorDegree2  startRadin $startRadin endRadin $endRadin");

      canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: tagRadius),
          startRadin, sweepRadin, true, _paint);

      if (isDrawLine) {
        _drawLineAndText(canvas, startRadin + sweepRadin / 2, sweepRadin,
            tagRadius, entity.title, entity.color,unitNumber);
      }

      startRadin += sweepRadin;
    }
    if (isDrawHelper) {
      // 绘制测试点
      _paint.color = Colors.black54;
      _paint.style = PaintingStyle.stroke;
      canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: radius),
          golbalStart, calculatorDegree2, true, _paint);
      canvas.drawCircle(Offset(downX, downY), 20, _paint);
    }

    if (pieProgress >= 1.0) {
      if (clickCallBack != null) {
        clickCallBack(currentSelect);
      }
    }
  }

//返回true 刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawLineAndText(Canvas canvas, double currentAngle, double angle,
      double r, String name, Color color,double unitNumber) {
// 绘制横线
// 1，计算开始坐标和转折点坐标
    var startX = r * (cos(currentAngle));
    var startY = r * (sin(currentAngle));
    var stopX = (r + line1) * (cos(currentAngle));
    var stopY = (r + line1) * (sin(currentAngle));

// 2、计算坐标在左边还是在右边，并计算横线结束坐标
    var endX;
    if (stopX - startX > 0) {
      endX = stopX + line2;
    } else {
      endX = stopX - line2;
    }

// 3、绘制斜线和横线
    canvas.drawLine(Offset(startX, startY), Offset(stopX, stopY), _paint);
    canvas.drawLine(Offset(stopX, stopY), Offset(endX, stopY), _paint);

// 4、绘制文字
// 绘制下方名称
// 上下间距偏移量
    var offset = 4;
// 1、测量文字
    var tp = _newVerticalAxisTextPainter(name, color);
    tp.layout();

    var w = tp.width;
// 2、计算文字坐标
    var textStartX;
    if (stopX - startX > 0) {
      if (w > line2) {
        textStartX = (stopX + offset);
      } else {
        textStartX = (stopX + (line2 - w) / 2);
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w);
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w);
      }
    }
    if (lineProgress >= 1.0) {
      tp.paint(canvas, Offset(textStartX, stopY + offset));
    }

// 绘制上方百分比，步骤同上
// todo 保留2为小数，确保精准度
    var per =  "${(unitNumber*100).round().toInt()}%";

    var tpPre = _newVerticalAxisTextPainter(per, color);
    tpPre.layout();

    w = tpPre.width;
    var h = tpPre.height;

    if (stopX - startX > 0) {
      if (w > line2) {
        textStartX = (stopX + offset);
      } else {
        textStartX = (stopX + (line2 - w) / 2);
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w);
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w);
      }
    }

    if (lineProgress >= 0.5) {
      tpPre.paint(canvas, Offset(textStartX, stopY - offset - h));
    }
  }

// 文字画笔 风格定义
  TextPainter _newVerticalAxisTextPainter(String text, Color color) {
    return _textPainter
      ..text = TextSpan(
        text: text,
        style: new TextStyle(
          color: color,
          fontSize: 12.0,
        ),
      );
  }

  /// 三个点：圆心A，半径r，度数0的点B,任意点C.
  /// 先计算∠BAC的度数（弧度）。
  double calculatorDegree(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    double radian = 0;

    double ab = getDistance(x1, y1, x2, y2);
    double ac = getDistance(x1, y1, x3, y3);
    double bc = getDistance(x2, y2, x3, y3);

    double value = (ab * ab + ac * ac - (bc * bc)) / (2 * ab * ac);

    radian = acos(value);

    return radian;
  }

  double getDistance(double x1, double y1, double x2, double y2) {
    double distance = 0;
    distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    return distance;
  }

  ///根据弧度计算度数并且计算AC距离。
  ///
}
