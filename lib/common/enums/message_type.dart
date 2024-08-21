enum MessageType {
  text('📝 Texto'),
  image('📷 Imagen'),
  video('🎥 Video'),
  audio('🔊 Audio'),
  file('📁 Archivo'),
  location('📍 Ubicación'),
  contact('🙍🏻 Contacto'),
  gif('GIF'),
  sticker('🎨 Sticker'),
  /// System message like user joined, left, etc.
  system('🔵 Sistema');

  final String formatted;

  const MessageType(this.formatted);
}
