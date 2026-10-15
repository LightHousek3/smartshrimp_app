import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';

part 'water_log_list_state.freezed.dart';

@freezed
abstract class WaterLogListState with _$WaterLogListState {
  const factory WaterLogListState({
    required WaterLogPage page,
    @Default(false) bool loadingMore,
    Object? paginationError,
  }) = _WaterLogListState;
}
