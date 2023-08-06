class NotificationModel {
  String _title = '';
  String _message = '';
  String _type = '';
  String _docId = '';

  get title => _title;
  get message => _message;
  get type => _type;
  get docId => _docId;

  NotificationModel(
      {required title, required message, required type, required docId}) {
    _title = title;
    _message = message;
    _type = type;
    _docId = docId;
  }

  // NotificationModel.fromJson(List<Object?> fromJson) : this(
  //   title: json
  // );
}
