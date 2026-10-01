import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_feedback.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm_location.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_map_page.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_location_map.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';

class FarmEditPage extends ConsumerWidget {
  const FarmEditPage({required this.farmId, this.initialFarm, super.key});

  final String farmId;
  final Farm? initialFarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = initialFarm;
    if (initial != null) return FarmFormPage(farm: initial);
    final state = ref.watch(farmDetailControllerProvider(farmId));
    return AppGradientBackground(
      child: SafeArea(
        child: state.when(
          data: (farm) => FarmFormPage(farm: farm),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    error is AppException
                        ? error.message
                        : 'Không thể tải trang trại.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: ref
                        .read(farmDetailControllerProvider(farmId).notifier)
                        .refresh,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FarmFormPage extends ConsumerStatefulWidget {
  const FarmFormPage({this.farm, super.key});

  final Farm? farm;

  @override
  ConsumerState<FarmFormPage> createState() => _FarmFormPageState();
}

class _FarmFormPageState extends ConsumerState<FarmFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _coordinateKey = GlobalKey<FormFieldState<String>>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _areaController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final FocusNode _addressFocusNode;
  late final FocusNode _areaFocusNode;

  var _locationRequest = 0;
  var _locating = false;
  var _geocoding = false;
  String? _locationError;
  String? _locationStatus;
  String? _lastGeocodedAddress;
  String? _submitError;

  bool get _isEditing => widget.farm != null;
  double? get _latitude => FarmRules.parseCoordinate(_latitudeController.text);
  double? get _longitude =>
      FarmRules.parseCoordinate(_longitudeController.text);
  bool get _hasMapLocation =>
      _latitude != null &&
      _longitude != null &&
      FarmRules.validateCoordinatePair(
            _latitudeController.text,
            _longitudeController.text,
          ) ==
          null;

  @override
  void initState() {
    super.initState();
    final farm = widget.farm;
    _nameController = TextEditingController(text: farm?.name ?? '');
    _addressController = TextEditingController(text: farm?.address ?? '');
    _areaController = TextEditingController(
      text: farm?.totalAreaHectares == null
          ? ''
          : formatCompactNumber(farm!.totalAreaHectares),
    );
    _latitudeController = TextEditingController(
      text: farm?.latitude?.toStringAsFixed(4) ?? '',
    );
    _longitudeController = TextEditingController(
      text: farm?.longitude?.toStringAsFixed(4) ?? '',
    );
    _lastGeocodedAddress = FarmRules.normalizeText(farm?.address ?? '');
    _addressFocusNode = FocusNode()..addListener(_handleAddressFocus);
    _areaFocusNode = FocusNode()..addListener(_handleAreaFocus);
  }

  @override
  void dispose() {
    _locationRequest++;
    _addressFocusNode
      ..removeListener(_handleAddressFocus)
      ..dispose();
    _areaFocusNode
      ..removeListener(_handleAreaFocus)
      ..dispose();
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _handleAddressFocus() {
    if (!_addressFocusNode.hasFocus) _geocodeAddress();
  }

  void _handleAreaFocus() {
    if (!_areaFocusNode.hasFocus) _normalizeAreaInput();
  }

  void _normalizeAreaInput() {
    final area = FarmRules.parseArea(_areaController.text);
    if (area == null) return;
    final normalized = formatCompactNumber(area);
    if (normalized == _areaController.text.trim()) return;
    _areaController.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(farmMutationControllerProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: <Widget>[
            StickyPageHeader(
              title: _isEditing ? 'Chỉnh sửa trang trại' : 'Tạo trang trại',
              subtitle: _isEditing ? widget.farm!.name : null,
              onBack: mutation.isLoading ? null : context.pop,
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _FarmFormField(
                        label: 'Tên trang trại *',
                        child: TextFormField(
                          controller: _nameController,
                          maxLength: FarmRules.nameMaxLength,
                          maxLines: 1,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: FarmRules.validateName,
                          decoration: _decoration('VD: Trang trại Cửa Lấp'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FarmFormField(
                        label: 'Địa chỉ',
                        child: TextFormField(
                          controller: _addressController,
                          focusNode: _addressFocusNode,
                          maxLength: FarmRules.addressMaxLength,
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          validator: FarmRules.validateAddress,
                          onChanged: (_) => setState(() {
                            _locationError = null;
                            _locationStatus = null;
                          }),
                          decoration: _decoration(
                            'Xã, huyện, tỉnh…',
                            suffix: _geocoding
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.ocean,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FarmFormField(
                        label: 'Diện tích tổng (ha)',
                        child: TextFormField(
                          controller: _areaController,
                          focusNode: _areaFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          validator: FarmRules.validateArea,
                          decoration: _decoration('VD: 3.5'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLocationCard(),
                      if (!_isEditing) ...<Widget>[
                        const SizedBox(height: 16),
                        const _CreateFarmHint(),
                      ],
                      if (_submitError != null) ...<Widget>[
                        const SizedBox(height: 16),
                        AppFormErrorBanner(message: _submitError!),
                      ],
                      const SizedBox(height: 24),
                      _buildSubmitButton(mutation.isLoading),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Vị trí trang trại',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _geocoding
                        ? 'Đang tìm tọa độ theo địa chỉ mới…'
                        : 'Chọn vị trí hiện tại để điền GPS tự động, hoặc điều chỉnh tọa độ bên dưới nếu cần.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10,
                      height: 1.625,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 40,
              child: FilledButton.icon(
                onPressed: _locating ? null : _useCurrentLocation,
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: const Color(0xFFEAF4FF),
                  disabledBackgroundColor: const Color(0xFFEAF4FF),
                  foregroundColor: const Color(0xFF0C4E8F),
                  disabledForegroundColor: AppColors.inkMuted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _locating
                    ? const SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.location_on_outlined, size: 14),
                label: Text(
                  _locating ? 'Đang lấy…' : 'Vị trí hiện tại',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_hasMapLocation)
          FarmLocationMap(
            latitude: _latitude!,
            longitude: _longitude!,
            height: 176,
          )
        else
          const _MapPlaceholder(),
        const SizedBox(height: 12),
        FormField<String>(
          key: _coordinateKey,
          validator: (_) => FarmRules.validateCoordinatePair(
            _latitudeController.text,
            _longitudeController.text,
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _FarmFormField(
                      label: 'Vĩ độ',
                      child: _coordinateInput(
                        controller: _latitudeController,
                        hint: '10.3462',
                        field: field,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FarmFormField(
                      label: 'Kinh độ',
                      child: _coordinateInput(
                        controller: _longitudeController,
                        hint: '107.0843',
                        field: field,
                      ),
                    ),
                  ),
                ],
              ),
              if (field.hasError) ...<Widget>[
                const SizedBox(height: 5),
                Text(
                  field.errorText!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_hasMapLocation) ...<Widget>[
          const SizedBox(height: 7),
          InkWell(
            onTap: _openLargeMap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Mở bản đồ lớn',
                    style: TextStyle(
                      color: AppColors.ocean,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: AppColors.ocean,
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_locationError != null || _locationStatus != null) ...<Widget>[
          const SizedBox(height: 5),
          Text(
            _locationError ?? _locationStatus!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _locationError == null
                  ? const Color(0xFF087C70)
                  : AppColors.error,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 5),
        const Text(
          'Tọa độ giúp đối chiếu đúng vị trí trang trại có nhiều khu ao hoặc địa chỉ khó tìm.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.inkMuted,
            fontSize: 10,
            height: 1.45,
          ),
        ),
      ],
    ),
  );

  TextFormField _coordinateInput({
    required TextEditingController controller,
    required String hint,
    required FormFieldState<String> field,
  }) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(
      signed: true,
      decimal: true,
    ),
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[-+0-9.,]')),
    ],
    maxLines: 1,
    style: AppTypography.mono(color: AppColors.ink, fontSize: 14),
    onChanged: (_) => _coordinateChanged(field),
    decoration: _decoration(hint),
  );

  Widget _buildSubmitButton(bool loading) => SizedBox(
    width: double.infinity,
    height: 46,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: loading
            ? null
            : const LinearGradient(
                colors: <Color>[AppColors.oceanLight, AppColors.tealLight],
              ),
        color: loading ? AppColors.line : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: loading
            ? null
            : const <BoxShadow>[
                BoxShadow(
                  color: Color(0x3377A1D3),
                  blurRadius: 13,
                  offset: Offset(0, 5),
                ),
              ],
      ),
      child: FilledButton.icon(
        onPressed: loading ? null : _submit,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: loading
            ? const SizedBox.square(
                dimension: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.inkMuted,
                ),
              )
            : const Icon(Icons.check_rounded, size: 19),
        label: Text(
          loading
              ? 'Đang lưu…'
              : _isEditing
              ? 'Lưu thay đổi'
              : 'Tạo trang trại',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );

  InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    counterText: '',
    suffixIcon: suffix == null
        ? null
        : Padding(padding: const EdgeInsets.all(13), child: suffix),
    suffixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 42),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
  );

  void _coordinateChanged(FormFieldState<String> field) {
    field.didChange('');
    setState(() {
      _locationError = null;
      _locationStatus = null;
    });
  }

  Future<void> _geocodeAddress() async {
    final address = FarmRules.normalizeText(_addressController.text);
    if (address.isEmpty || address == _lastGeocodedAddress || _geocoding) {
      return;
    }
    final request = ++_locationRequest;
    setState(() {
      _geocoding = true;
      _locationError = null;
      _locationStatus = null;
    });
    try {
      final result = await ref
          .read(farmGeocodingServiceProvider)
          .findByAddress(address);
      if (!mounted || request != _locationRequest) return;
      _lastGeocodedAddress = address;
      if (result == null) {
        setState(() {
          _locationError =
              'Không tìm thấy tọa độ phù hợp. Bạn có thể nhập tọa độ thủ công.';
        });
        return;
      }
      _applyLocation(result);
      setState(() => _locationStatus = 'Đã cập nhật tọa độ theo địa chỉ.');
    } on AppException catch (error) {
      if (mounted && request == _locationRequest) {
        setState(() => _locationError = error.message);
      }
    } finally {
      if (mounted && request == _locationRequest) {
        setState(() => _geocoding = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    final request = ++_locationRequest;
    FocusScope.of(context).unfocus();
    setState(() {
      _locating = true;
      _locationError = null;
      _locationStatus = null;
    });
    try {
      final location = await ref
          .read(deviceLocationServiceProvider)
          .getCurrentLocation();
      if (!mounted || request != _locationRequest) return;
      _applyLocation(location);
      setState(() {
        final accuracy = location.accuracyMeters?.round();
        _locationStatus = accuracy == null
            ? 'Đã chọn vị trí hiện tại.'
            : 'Đã chọn vị trí hiện tại · độ chính xác khoảng $accuracy m.';
      });

      final reversed = await ref
          .read(farmGeocodingServiceProvider)
          .findByCoordinates(
            latitude: location.latitude,
            longitude: location.longitude,
          );
      if (!mounted || request != _locationRequest) return;
      final address = reversed?.displayAddress;
      if (address != null && address.isNotEmpty) {
        _addressController.text = address;
        _lastGeocodedAddress = FarmRules.normalizeText(address);
      }
    } on AppException catch (error) {
      if (mounted && request == _locationRequest) {
        setState(() => _locationError = error.message);
      }
    } finally {
      if (mounted && request == _locationRequest) {
        setState(() => _locating = false);
      }
    }
  }

  void _applyLocation(FarmLocation location) {
    _latitudeController.text = location.latitude.toStringAsFixed(6);
    _longitudeController.text = location.longitude.toStringAsFixed(6);
    _coordinateKey.currentState?.didChange('');
    setState(() {});
  }

  void _openLargeMap() {
    if (!_hasMapLocation) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => FarmMapPage(
          latitude: _latitude!,
          longitude: _longitude!,
          farmName: _nameController.text.trim().isEmpty
              ? 'Trang trại mới'
              : _nameController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    _normalizeAreaInput();
    setState(() => _submitError = null);
    final formValid = _formKey.currentState?.validate() ?? false;
    final coordinatesValid = _coordinateKey.currentState?.validate() ?? false;
    if (!formValid || !coordinatesValid) return;
    try {
      final notifier = ref.read(farmMutationControllerProvider.notifier);
      final result = _isEditing
          ? await notifier.updateFarm(
              farmId: widget.farm!.id,
              name: _nameController.text,
              address: _addressController.text,
              latitude: _latitude,
              longitude: _longitude,
              totalAreaHectares: FarmRules.parseArea(_areaController.text),
            )
          : await notifier.create(
              name: _nameController.text,
              address: _addressController.text,
              latitude: _latitude,
              longitude: _longitude,
              totalAreaHectares: FarmRules.parseArea(_areaController.text),
            );
      if (!mounted) return;
      if (_isEditing) {
        AppFeedback.success(context, 'Cập nhật trang trại thành công.');
        context.pop(result);
      } else {
        context.go('/farms?created=1');
      }
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _submitError = error.message);
    }
  }
}

class _FarmFormField extends StatelessWidget {
  const _FarmFormField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.inkSoft,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 146,
    decoration: BoxDecoration(
      color: const Color(0xFFEEF1F6),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFEEF1F7)),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFD3E8FF),
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: 40,
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.ocean,
              size: 18,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Chọn vị trí hiện tại để xem bản đồ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.inkSoft,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _CreateFarmHint extends StatelessWidget {
  const _CreateFarmHint();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF4FF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFC4E0FF)),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.info_outline_rounded, color: AppColors.ocean, size: 18),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Sau khi tạo trang trại, bạn có thể thêm ao nuôi và bắt đầu quản lý vụ nuôi.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF0C4E8F),
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ),
      ],
    ),
  );
}
