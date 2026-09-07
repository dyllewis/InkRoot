String shortFirstLine(Object error) => error.toString().split('\n').first;

bool isTokenExpiredError(Object error) {
  final s = error.toString();
  return s.contains('Token无效或已过期');
}

/// 判断错误是否属于网络不可达类故障（服务器暂时离线、DNS 失败、超时、TLS 握手失败等）。
/// 此类情况应保留本地凭据等待网络恢复，而不是把用户登出。
bool isNetworkFailureError(Object error) {
  final s = error.toString().toLowerCase();
  return s.contains('无法连接到服务器') ||
      s.contains('连接服务器超时') ||
      s.contains('连接超时') ||
      s.contains('网络连接失败') ||
      s.contains('socketexception') ||
      s.contains('timeoutexception') ||
      s.contains('clientexception') ||
      s.contains('connection refused') ||
      s.contains('connection closed') ||
      s.contains('connection reset') ||
      s.contains('network is unreachable') ||
      s.contains('failed host lookup') ||
      s.contains('handshakeexception') ||
      s.contains('tlsexception');
}

String syncFailedMessage(Object error) => '同步失败: ${shortFirstLine(error)}';
