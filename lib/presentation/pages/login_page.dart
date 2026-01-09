import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/session_manager.dart';
import '../../core/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.background : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 32.h,
          ),
          child: SizedBox(
            height: 1.sh - 64.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // -------- APP ICON --------
                Icon(
                  Icons.task_alt,
                  size: 64.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),

                // -------- TITLE --------
                Text(
                  'TaskFlow Mini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 6.h),

                Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.textSecondaryLight,
                  ),
                ),

                SizedBox(height: 40.h),

                // -------- EMAIL --------
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor:
                    isDark ? AppColors.card : AppColors.cardLight,
                    labelStyle: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.border
                            : AppColors.borderLight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // -------- PASSWORD --------
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor:
                    isDark ? AppColors.card : AppColors.cardLight,
                    labelStyle: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.border
                            : AppColors.borderLight,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // -------- LOGIN BUTTON --------
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // -------- DEMO ACCOUNTS --------
                Column(
                  children: [
                    Text(
                      'Demo Accounts',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Admin: admin@test.com / 123456\n'
                          'Staff: staff1@test.com / 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------- LOGIN HANDLER --------
  void _onLogin() {
    final user = AuthService.login(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
      return;
    }

    SessionManager.saveUser(user.id);
    context.go('/');
  }
}
