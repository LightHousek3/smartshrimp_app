import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

String pondTypeLabel(PondType type) => switch (type) {
  PondType.aquaculture => 'Ao nuôi',
  PondType.waterTreatment => 'Ao xử lý nước',
  PondType.unknown => 'Không xác định',
};

String pondStatusLabel(PondStatus status) => switch (status) {
  PondStatus.available => 'Sẵn sàng',
  PondStatus.maintenance => 'Bảo trì',
  PondStatus.inactive => 'Ngừng hoạt động',
  PondStatus.unknown => 'Không xác định',
};
