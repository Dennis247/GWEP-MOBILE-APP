class WaterBodyData {
  List<WaterBody>? data;
  bool? succeeded;
  String? message;

  WaterBodyData({this.data, this.succeeded, this.message});

  WaterBodyData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WaterBody>[];
      json['data'].forEach((v) {
        data!.add(new WaterBody.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['message'] = this.message;
    return data;
  }
}

class WaterBody {
  int? id;
  String? filePath;
  String? fileName;
  String? name;
  String? created;

  String get displayName {
    var dName = name!.replaceAll("_", " ");
    dName = dName.replaceAll(" FINAL", "");
    return dName;
  }

  WaterBody({this.id, this.filePath, this.fileName, this.name, this.created});

  WaterBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePath = json['filePath'];
    fileName = json['fileName'];
    name = json['name'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['filePath'] = this.filePath;
    data['fileName'] = this.fileName;
    data['name'] = this.name;
    data['created'] = this.created;
    return data;
  }
}
