String shortFirstLine(Object error) => error.toString().split('\n').first;

bool isTokenExpiredError(Object error) {
  final s = error.toString();
  return s.contains('Token无效或已过期');
}

/// 判断错误是否属于网络不可达类故障（服务器暂时离线、DNS 失败、超时、TLS 握手失败等）。
/// 此类情况应保留本地凭据等待网络恢复，而不是把用户登出。
///
/// 除传输层错误外，也包含 HTTP 层的暂时性故障（5xx、429 限流）——
/// 自建 Memos 常经由反向代理暴露，服务器升级/重启窗口内最常见的就是 502/503，
/// 这些场景下凭据并没有失效，同样应当保留等待重试。
final RegExp _transientHttpStatus = RegExp(r':\s*(429|5\d\d)\b');

bool isNetworkFailureError(Object error) {
  final s = error.toString().toLowerCase();
  if (s.contains('无法连接到服务器') ||
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
      s.contains('tlsexception')) {
    return true;
  }
  if (_transientHttpStatus.hasMatch(s)) {
    return true;
  }
  // 反向代理/网关直接返回的错误正文（如 Nginx 502 页面被透传时）
  return s.contains('bad gateway') ||
      s.contains('service unavailable') ||
      s.contains('internal server error') ||
      s.contains('too many requests') ||
      s.contains('server overloaded');
}

/// 判断错误是否为服务器对凭据的明确拒绝（密码错误、用户不存在等）。
/// 只有命中此判定的失败才允许清除本地凭据并要求用户重新登录；
/// 其余失败一律按暂时性处理，保留凭据等待下次自动重试。
bool isCredentialFailureError(Object error) {
  final s = error.toString().toLowerCase();
  return s.contains('账号或密码错误') ||
      s.contains('密码错误') ||
      s.contains('用户不存在') ||
      s.contains('incorrect login credentials') ||
      s.contains('invalid username or password') ||
      s.contains('invalid credentials') ||
      s.contains('wrong password');
}

String syncFailedMessage(Object error) => '同步失败: ${shortFirstLine(error)}';
