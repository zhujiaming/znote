class BaseRepo {
  bool _isClosed = false;

  bool get isClosed => _isClosed;

  void onClose() {
    _isClosed = true;
  }
}
