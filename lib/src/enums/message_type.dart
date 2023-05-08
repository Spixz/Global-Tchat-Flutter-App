enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageType(this.value);
  final String value;

  @override
  String toString() => value;
}
