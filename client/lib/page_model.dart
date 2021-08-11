import 'dart:convert';
import 'dart:developer';

class PageModel {
  late List<Records> records;
  late int total;
  late int size;
  late int current;
  late int pages;

  PageModel(
      {required this.records,
      required this.total,
      required this.size,
      required this.current,
      required this.pages});

  PageModel.fromJson(dynamic json) {
    records = <Records>[];
    if (json['records'] != null) {
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
    total = json['total'];
    size = json['size'];
    current = json['current'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['records'] = this.records.map((v) => v.toJson()).toList();
    data['total'] = this.total;
    data['size'] = this.size;
    data['current'] = this.current;
    data['pages'] = this.pages;
    return data;
  }
}

class Records {
  late int id;
  late String title;
  late String content;
  late bool deleteFlag;
  DateTime? createTime;

  Records(
      {required this.id,
      required this.title,
      required this.content,
      required this.deleteFlag,
      this.createTime});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    deleteFlag = json['deleteFlag'];
    createTime = DateTime.parse(json['createTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['deleteFlag'] = this.deleteFlag;
    data['createTime'] = this.createTime!.toIso8601String();
    return data;
  }
}
