import 'package:flutter/material.dart';
import 'package:login2/setting/alartpasstrue.dart';
import 'package:login2/setting/setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login2/login/login.dart';

final supabase = Supabase.instance.client;

class PasswordManager extends StatefulWidget {
  @override
  _PasswordManagerState createState() => _PasswordManagerState();
}

class _PasswordManagerState extends State<PasswordManager> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _oldPasswordError; // ← تخزين الخطأ لكلمة المرور القديمة

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = supabase.auth.currentUser;
    if (user == null) {
      _showSnackBar("User not logged in!");
      return;
    }

    FocusScope.of(context).unfocus(); // ← إخفاء لوحة المفاتيح

    setState(() {
      _isLoading = true;
      _oldPasswordError = null;
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      if (response.session == null || response.user == null) {
        throw AuthException("Failed to verify old password");
      }

      await supabase.auth.refreshSession();

      if (_oldPasswordController.text == _newPasswordController.text) {
        _showSnackBar("New password must be different from the old password.");
        setState(() => _isLoading = false);
        return;
      }

      await supabase.auth.updateUser(
        UserAttributes(password: _newPasswordController.text),
      );

      // ✅ استدعاء الـ AlertDialog عند النجاح
      _showSuccessDialog();
    } on AuthException catch (error) {
      if (error.message.contains("Invalid login credentials")) {
        setState(() {
          _oldPasswordError = "Old password is incorrect!";
          _oldPasswordController.clear();
        });
      } else {
        _showSnackBar("Error: ${error.message}");
      }
    } catch (error) {
      _showSnackBar("Error: ${error.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congrats!"),
        content: const Text("Your password has been changed successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الـ AlertDialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.zero, // إزالة التباعد الداخلي لتنسيق أفضل
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3CAB72),
                    Color(0xFF24744B),
                    Color(0xFF0A4627)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Password Manager',
          style: TextStyle(
            color: Color(0xFF0A4627),
            fontSize: 28,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                "Old Password",
                _oldPasswordController,
                _obscureOldPassword,
                () {
                  setState(() => _obscureOldPassword = !_obscureOldPassword);
                },
                errorText: _oldPasswordError, // ← تمرير الخطأ هنا
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                "New Password",
                _newPasswordController,
                _obscureNewPassword,
                () {
                  setState(() => _obscureNewPassword = !_obscureNewPassword);
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                "Confirm Password",
                _confirmPasswordController,
                _obscureConfirmPassword,
                () {
                  setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
                validateConfirmPassword: true,
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback toggleVisibility, {
    bool validateConfirmPassword = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0C0C0C),
            fontSize: 18,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            errorText: errorText, // ← عرض الخطأ في واجهة المستخدم
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your $label";
            }
            if (validateConfirmPassword &&
                value != _newPasswordController.text) {
              return "Passwords do not match";
            }
            if (!validateConfirmPassword && value.length < 6) {
              return "Password must be at least 6 chars";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Make button background transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets
              .zero, // Remove default padding to allow for full gradient area
        ).copyWith(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3CAB72), Color(0xFF24744B), Color(0xFF0A4627)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
