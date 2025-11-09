import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<String> selectedImages;
  final Function(List<String>) onImagesChanged;
  final int maxImages;

  const ImagePickerWidget({
    super.key,
    required this.selectedImages,
    required this.onImagesChanged,
    this.maxImages = 5,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedImages = List<String>.from(widget.selectedImages)
        ..add(photo.path);
      widget.onImagesChanged(updatedImages);

      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        final remainingSlots = widget.maxImages - widget.selectedImages.length;
        final imagesToAdd =
            images.take(remainingSlots).map((e) => e.path).toList();
        final updatedImages = List<String>.from(widget.selectedImages)
          ..addAll(imagesToAdd);
        widget.onImagesChanged(updatedImages);
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  void _removeImage(int index) {
    final updatedImages = List<String>.from(widget.selectedImages)
      ..removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  void _reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final updatedImages = List<String>.from(widget.selectedImages);
    final item = updatedImages.removeAt(oldIndex);
    updatedImages.insert(newIndex, item);
    widget.onImagesChanged(updatedImages);
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera && _isCameraInitialized && _cameraController != null) {
      return _buildCameraView();
    }

    return _buildImageGrid();
  }

  Widget _buildCameraView() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CameraPreview(_cameraController!),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => setState(() => _showCamera = false),
                  icon: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _pickFromGallery,
                  icon: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'photo_library',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos (${widget.selectedImages.length}/${widget.maxImages})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.selectedImages.length +
                (widget.selectedImages.length < widget.maxImages ? 1 : 0),
            onReorder: _reorderImages,
            itemBuilder: (context, index) {
              if (index == widget.selectedImages.length) {
                return _buildAddImageCard(index);
              }
              return _buildImageCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(int index) {
    return Container(
      key: ValueKey('image_$index'),
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: widget.selectedImages[index],
              width: 40.w,
              height: 25.h,
              fit: BoxFit.cover,
              semanticLabel: "Selected item photo ${index + 1} for listing",
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ),
          if (index == 0)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Main',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddImageCard(int index) {
    return Container(
      key: ValueKey('add_image_$index'),
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add_a_photo',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Add Photo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add Photo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _showCamera = true);
                  },
                ),
                _buildSourceOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.lightTheme.dividerColor),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
