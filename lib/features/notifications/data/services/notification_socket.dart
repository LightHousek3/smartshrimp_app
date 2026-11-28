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
    void Function(String id, DateTime readAt)? onRead,
    io.Socket? socket,
  }) : _apiClient = apiClient,
       _onChanged = onChanged,
       _onSessionExpired = onSessionExpired {
    _socket =
        socket ??
        io.io(
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
      ..onConnect((_) {
        _onChanged();
        _caseChanges.add(null);
        // Initial dashboard load already reads current data; only recovery needs a reload.
        if (_hasConnected) _dashboardChanges.add(null);
        _hasConnected = true;
      })
      ..on('notification:new', (payload) {
        _onChanged();
        // Treatment lifecycle notices reference the season, not always the case.
        // Keep this stream separate so existing case subscribers retain their scope.
        _dashboardChanges.add(null);
        if (payload is! Map) return;
        final referenceType = payload['referenceType'];
        // Older producers send only a notification id. Reload active cases
        // in that case; the API remains responsible for access checks.
        if (referenceType == null || referenceType == 'disease_case') {
          final id = payload['referenceId'];
          _caseChanges.add(id is String && id.isNotEmpty ? id : null);
        }
      })
      ..on('notification:read', (payload) {
        if (onRead != null && payload is Map) {
          final id = payload['id'];
          final value = payload['readAt'];
          final readAt = value is String ? DateTime.tryParse(value) : null;
          if (id is String && id.isNotEmpty && readAt != null) {
            onRead(id, readAt);
            return;
          }
        }
        _onChanged();
      })
      ..on('notification:read-all', (_) => _onChanged())
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
  final _caseChanges = StreamController<String?>.broadcast();
  final _dashboardChanges = StreamController<void>.broadcast();
  bool _hasConnected = false;

  /// A null id means reconnect or an event without reference metadata.
  Stream<String?> get caseChanges => _caseChanges.stream;
  Stream<void> get dashboardChanges => _dashboardChanges.stream;

  void connect() => _socket.connect();

  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _socket.dispose();
    _caseChanges.close();
    _dashboardChanges.close();
  }
}
