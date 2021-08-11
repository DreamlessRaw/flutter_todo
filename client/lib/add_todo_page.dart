import 'dart:convert';
import 'dart:developer';

import 'package:client/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ndialog/ndialog.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加记事本'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _contentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('信息未填写完整'),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  var todo = Map<String, String>();
                  todo['title'] = _titleController.text;
                  todo['content'] = _contentController.text;
                  log(jsonEncode(todo));
                  var progressDialog = ProgressDialog(context,
                      title: Text('提示'),
                      message: Text('网络请求中'),
                      backgroundColor: Colors.white70,
                      dismissable: false);
                  progressDialog.show();
                  Global.dio.post('todo/create', data: todo).then((value) {
                    var data = value.data;
                    var success = data['code'] == 0;
                    progressDialog.dismiss();
                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(data['msg']),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  });
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            maxLines: 1,
            maxLength: 10,
            decoration: InputDecoration(
                hintText: '请输入标题……',
                contentPadding: EdgeInsets.only(left: 8.0)),
          ),
          Expanded(
            child: TextField(
              controller: _contentController,
              minLines: 10,
              maxLines: 10,
              maxLength: 200,
              decoration: InputDecoration(
                  hintText: '请输入内容……',
                  contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
                  border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}
