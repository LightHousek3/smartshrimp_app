import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';

final class NotificationSocket {
  NotificationSocket({
    required String serverUrl,
    required ApiClient apiClient,
    required void Function() onChanged,
    required void Function() onSessionExpired,
  }) : _apiClient = apiClient,
       _onChanged = onChanged,
       _onSessionExpired = onSessionExpired {
    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .setAuthFn((callback) async {
            try {
              callback(<String, String>{
                'token': await _apiClient.accessTokenForRealtime(),
              });
            } on SessionExpiredException {
              if (!_disposed) _onSessionExpired();
              callback(<String, String>{'token': ''});
            } on Object {
              callback(<String, String>{'token': ''});
            }
          })
          .build(),
    );
    _socket
      ..onConnect((_) => _onChanged())
      ..on('notification:new', (_) => _onChanged())
      ..on('notification:read', (_) => _onChanged())
      ..onConnectError((error) {
        if (_disposed || !error.toString().contains('Unauthorized')) return;
        _retry?.cancel();
        _retry = Timer(const Duration(seconds: 5), () {
          if (!_disposed) _socket.connect();
        });
      });
  }

  final ApiClient _apiClient;
  final void Function() _onChanged;
  final void Function() _onSessionExpired;
  late final io.Socket _socket;
  Timer? _retry;
  bool _disposed = false;

  void connect() => _socket.connect();

  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _socket.dispose();
  }
}
