class NotificationModel {
  String _title = '';
  String _message = '';
  String _type = '';

  get title => _title;
  get message => _message;
  get type => _type;

  NotificationModel({required title, required message, required type}) {
    _title = title;
    _message = message;
    _type = type;
  }

  // NotificationModel.fromJson(List<Object?> fromJson) : this(
  //   title: json
  // );
}
