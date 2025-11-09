import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_picker_widget.dart';
import './widgets/condition_selector_widget.dart';
import './widgets/image_picker_widget.dart';
import './widgets/trade_preferences_widget.dart';
import './widgets/value_slider_widget.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> _selectedImages = [];
  String? _selectedCategory;
  String? _selectedCondition;
  double _estimatedValue = 100.0;
  bool _willingToAddCoins = false;
  bool _localPickupOnly = true;
  bool _shippingAvailable = false;
  bool _hideSpecificAddress = false;
  bool _showAdvancedOptions = false;
  bool _isPosting = false;
  bool _autoSaveDraft = true;

  @override
  void initState() {
    super.initState();
    _startAutoSave();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _startAutoSave() {
    if (_autoSaveDraft) {
      Future.delayed(Duration(seconds: 30), () {
        if (mounted && _autoSaveDraft) {
          _saveDraft();
          _startAutoSave();
        }
      });
    }
  }

  void _saveDraft() {
    if (_titleController.text.isNotEmpty || _selectedImages.isNotEmpty) {
      // Auto-save draft logic would go here
      debugPrint('Draft saved automatically');
    }
  }

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedCondition != null &&
        _selectedImages.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        leading: IconButton(
          onPressed: () => _showCancelDialog(),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid && !_isPosting ? _postItem : null,
            child: _isPosting
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Post',
                    style: TextStyle(
                      color: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(
                selectedImages: _selectedImages,
                onImagesChanged: (images) =>
                    setState(() => _selectedImages = images),
                maxImages: 5,
              ),
              SizedBox(height: 4.h),
              _buildTitleField(),
              SizedBox(height: 3.h),
              _buildCategorySection(),
              SizedBox(height: 3.h),
              ConditionSelectorWidget(
                selectedCondition: _selectedCondition,
                onConditionSelected: (condition) =>
                    setState(() => _selectedCondition = condition),
              ),
              SizedBox(height: 3.h),
              _buildDescriptionField(),
              SizedBox(height: 3.h),
              ValueSliderWidget(
                currentValue: _estimatedValue,
                onValueChanged: (value) =>
                    setState(() => _estimatedValue = value),
                minValue: 1.0,
                maxValue: 1000.0,
              ),
              SizedBox(height: 3.h),
              _buildLocationSection(),
              SizedBox(height: 3.h),
              _buildAdvancedOptionsSection(),
              SizedBox(height: 6.h),
              _buildPostButton(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'What are you trading?',
            counterText: '${_titleController.text.length}/60',
          ),
          maxLength: 60,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title for your item';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        CategoryPickerWidget(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) =>
              setState(() => _selectedCategory = category),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText:
                'Describe your item, its condition, and any important details...',
            counterText: '${_descriptionController.text.length}/500',
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          maxLength: 500,
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.lightTheme.dividerColor),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hideSpecificAddress
                          ? 'General Area'
                          : 'Specific Address',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _hideSpecificAddress
                          ? 'San Francisco Bay Area, CA'
                          : '123 Market Street, San Francisco, CA 94102',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _hideSpecificAddress,
                onChanged: (value) =>
                    setState(() => _hideSpecificAddress = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _showAdvancedOptions = !_showAdvancedOptions),
          child: Row(
            children: [
              Text(
                'Advanced Options',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: _showAdvancedOptions
                    ? 'keyboard_arrow_up'
                    : 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ],
          ),
        ),
        if (_showAdvancedOptions) ...[
          SizedBox(height: 2.h),
          TradePreferencesWidget(
            willingToAddCoins: _willingToAddCoins,
            localPickupOnly: _localPickupOnly,
            shippingAvailable: _shippingAvailable,
            onWillingToAddCoinsChanged: (value) =>
                setState(() => _willingToAddCoins = value),
            onLocalPickupOnlyChanged: (value) =>
                setState(() => _localPickupOnly = value),
            onShippingAvailableChanged: (value) =>
                setState(() => _shippingAvailable = value),
          ),
        ],
      ],
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isPosting ? _postItem : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          backgroundColor: _isFormValid
              ? AppTheme.lightTheme.colorScheme.secondary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
        ),
        child: _isPosting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Posting Item...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Post Item',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _showCancelDialog() {
    final hasContent = _titleController.text.isNotEmpty ||
        _selectedImages.isNotEmpty ||
        _descriptionController.text.isNotEmpty;

    if (!hasContent) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?'),
        content:
            Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Discard',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _postItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPosting = true);

    try {
      // Simulate posting process
      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        setState(() => _isPosting = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPosting = false);
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Item Posted Successfully!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your item is now live and ready for trading.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add-item');
            },
            child: Text('Add Another Item'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/marketplace-home');
            },
            child: Text('View Listing'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Upload Failed'),
          ],
        ),
        content: Text(
          'There was a problem posting your item. Please check your internet connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
