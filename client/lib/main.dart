import 'dart:convert';
import 'dart:developer';

import 'package:client/add_todo_page.dart';
import 'package:client/global.dart';
import 'package:client/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '记事本',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '记事本'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Records> _records = <Records>[];
  bool _isNext = true;
  int _nextPage = 1;
  int _size = 10;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData(_nextPage, _size);
      }
    });
    Future.delayed(Duration(seconds: 3), () => _getData(_nextPage, _size));
  }

  _getData(int page, int size) {
    if (_isNext || page == 1) {
      Global.dio.get('todo/list/$page/$size').then((value) {
        try {
          var pageModel = PageModel.fromJson(value.data);
          this.setState(() {
            _records.addAll(pageModel.records);
            _isNext = pageModel.pages > _nextPage;
            _nextPage = page + 1;
          });
          log('页数:$_nextPage,是否有下一页:$_isNext');
        } on Exception catch (ex) {
          log(ex.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddTodoPage();
                })).then((value) {
                  if (value == true) {
                    _getData(1, _size);
                  }
                });
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            if (_records.length == 0) return Divider();
            var item = _records[i];
            return GestureDetector(
              child: Card(
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide.none),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                        width: double.infinity,
                        height: 200,
                        image: AssetImage('assets/aestheticism.png'),
                        fit: BoxFit.cover),
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 12),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: item.title,
                            style: TextStyle(
                              fontSize: 24,
                            )),
                        TextSpan(
                            text: DateFormat('yyyy-MM-dd HH:mm')
                                .format(item.createTime!),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500))
                      ])),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        item.content,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: Text('提示'),
                        message: Text('确定要删除-${item.title}?'),
                        actions: [
                          CupertinoButton(
                              child: Text(
                                '删除',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                var progressDialog = ProgressDialog(context,
                                    title: Text('提示'),
                                    message: Text('网络请求中'),
                                    backgroundColor: Colors.white70,
                                    dismissable: false);
                                progressDialog.show();
                                Global.dio
                                    .post('todo/delete', data: item.toJson())
                                    .then((value) {
                                  var data = value.data;
                                  var success = data['code'] == 0;
                                  progressDialog.dismiss();
                                  Navigator.pop(context);
                                  if (success) {
                                    _getData(1, 10);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('删除成功'),
                                      duration: Duration(seconds: 1),
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(data['msg'].toString()),
                                      duration: Duration(seconds: 2),
                                      action: SnackBarAction(
                                          label: '关闭',
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ));
                                  }
                                });
                              }),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
              },
            );
          },
          itemCount: _records.length,
        ),
        onRefresh: () async => {await _getData(1, 10)},
        //指示器显示时距顶部位置
        color: Colors.white,
        //指示器颜色，默认ThemeData.accentColor
        backgroundColor: Colors.blue,
        //指示器背景颜色，默认ThemeData.canvasColor
        notificationPredicate: defaultScrollNotificationPredicate,
      ),
    );
  }
}
