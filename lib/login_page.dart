import 'package:flutter/material.dart';

// ============================================================================
// STATE MANAGEMENT (School Portal Authentication Controller)
// ============================================================================

enum AuthStatus { initial, loading, success, failure }

class LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final AuthStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginController extends ValueNotifier<LoginState> {
  LoginController() : super(const LoginState());

  void updateEmail(String email) {
    value = value.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    value = value.copyWith(password: password, errorMessage: null);
  }

  void togglePasswordVisibility() {
    value = value.copyWith(isPasswordVisible: !value.isPasswordVisible);
  }

  Future<void> submitLogin() async {
    value = value.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (value.email == 'error@school.edu') {
        throw Exception('Invalid Student ID or password.');
      }

      value = value.copyWith(status: AuthStatus.success);
    } catch (e) {
      value = value.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loginWithSocial(String provider) async {
    value = value.copyWith(status: AuthStatus.loading, errorMessage: null);
    await Future.delayed(const Duration(seconds: 1));
    value = value.copyWith(status: AuthStatus.success, email: '$provider User');
  }
}

// ============================================================================
// SCHOOL LOGIN SCREEN WIDGET
// ============================================================================

class CleanLoginScreen extends StatefulWidget {
  const CleanLoginScreen({super.key});

  @override
  State<CleanLoginScreen> createState() => _CleanLoginScreenState();
}

class _CleanLoginScreenState extends State<CleanLoginScreen> {
  late final LoginController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
    _controller.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final state = _controller.value;
    if (state.status == AuthStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back to Campus Portal, ${state.email}!'),
          backgroundColor: const Color(0xFF1B4332),
        ),
      );
    } else if (state.status == AuthStatus.failure && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const navyPrimary = Color(0xFF1E3A8A);
    const campusBackground = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: campusBackground,
      body: Stack(
        children: [
          // Institutional Header Accent Banner (gives a school administrative theme feel)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Main Login Content Form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: ValueListenableBuilder<LoginState>(
                  valueListenable: _controller,
                  builder: (context, state, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // School Logo / Crest Header Card
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 36,
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 42,
                                  color: navyPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Oakridge University',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Student & Staff Portal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFE0E7FF),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Form Card Container
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Email / Student ID Field
                                Text(
                                  'Student Email or ID',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  onChanged: _controller.updateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'e.g., alex.smith@oakridge.edu',
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF64748B)),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: navyPrimary, width: 2),
                                    ),
                                  ),
                                  validator: (val) =>
                                  val != null && val.trim().isNotEmpty ? null : 'Please enter your student ID or email',
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  onChanged: _controller.updatePassword,
                                  obscureText: !state.isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                        color: const Color(0xFF64748B),
                                      ),
                                      onPressed: _controller.togglePasswordVisibility,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: navyPrimary, width: 2),
                                    ),
                                  ),
                                  validator: (val) => val != null && val.length >= 6 ? null : 'Minimum 6 characters required',
                                ),
                                const SizedBox(height: 24),

                                // Portal Login Button
                                ElevatedButton(
                                  onPressed: state.status == AuthStatus.loading
                                      ? null
                                      : () {
                                    if (_formKey.currentState!.validate()) {
                                      _controller.submitLogin();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navyPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: state.status == AuthStatus.loading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                      : const Text(
                                    'Sign In to Portal',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Divider
                                Row(
                                  children: const [
                                    Expanded(child: Divider(color: Color(0xFFCBD5E1))),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'OR CONNECT WITH',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: Color(0xFFCBD5E1))),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Social Login Grid Buttons (Google, Facebook, Twitter/X, Instagram)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _SocialAuthButton(
                                      icon: Icons.g_mobiledata_rounded,
                                      iconColor: const Color(0xFFEA4335),
                                      label: 'Google',
                                      onTap: () => _controller.loginWithSocial('Google'),
                                    ),
                                    _SocialAuthButton(
                                      icon: Icons.facebook_rounded,
                                      iconColor: const Color(0xFF1877F2),
                                      label: 'Facebook',
                                      onTap: () => _controller.loginWithSocial('Facebook'),
                                    ),
                                    _SocialAuthButton(
                                      icon: Icons.alternate_email_rounded,
                                      iconColor: const Color(0xFF1DA1F2),
                                      label: 'Twitter',
                                      onTap: () => _controller.loginWithSocial('Twitter'),
                                    ),
                                    _SocialAuthButton(
                                      icon: Icons.camera_alt_outlined,
                                      iconColor: const Color(0xFFE4405F),
                                      label: 'Instagram',
                                      onTap: () => _controller.loginWithSocial('Instagram'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Social Login Icons
class _SocialAuthButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _SocialAuthButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 58,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    );
  }
}