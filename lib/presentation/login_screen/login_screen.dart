import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';
import './widgets/truek_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _errorMessage = '';

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@truekapp.com': 'admin123',
    'user@truekapp.com': 'user123',
    'trader@truekapp.com': 'trader123',
  };

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        // Navigate to marketplace home
        Navigator.pushReplacementNamed(context, '/marketplace-home');
      }
    } else {
      // Error handling
      setState(() {
        _isLoading = false;
        if (!_mockCredentials.containsKey(email)) {
          _errorMessage = 'Account not found. Please check your email address.';
        } else {
          _errorMessage = 'Invalid password. Please try again.';
        }
      });

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    }
  }

  void _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate social login process
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, social login always succeeds
    HapticFeedback.lightImpact();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/marketplace-home');
    }
  }

  void _navigateToSignUp() {
    // For demo purposes, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up functionality coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),

                  // Logo Section
                  const TruekLogoWidget(),
                  SizedBox(height: 6.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Sign in to continue trading',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 4.h),

                  // Social Login Options
                  SocialLoginWidget(
                    isLoading: _isLoading,
                    onSocialLogin: _handleSocialLogin,
                  ),
                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to TruekApp? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : _navigateToSignUp,
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Demo Credentials Info
                  if (_errorMessage.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Demo Credentials',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'admin@truekapp.com / admin123\nuser@truekapp.com / user123\ntrader@truekapp.com / trader123',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onErrorContainer,
                                      height: 1.4,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
