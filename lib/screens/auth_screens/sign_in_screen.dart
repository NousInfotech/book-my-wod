import 'dart:ffi';
import 'dart:io';

import 'package:bookmywod_admin/bloc/auth_bloc.dart';
import 'package:bookmywod_admin/bloc/events/auth_event_login.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart' as CustomAuthState;
import 'package:bookmywod_admin/bloc/states/auth_state_logged_out.dart';
import 'package:bookmywod_admin/services/auth/auth_exceptions.dart';
import 'package:bookmywod_admin/shared/constants/Icons.dart';
import 'package:bookmywod_admin/shared/constants/bg_gardient.dart';
import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:bookmywod_admin/shared/constants/regex.dart';
import 'package:bookmywod_admin/shared/custom_button.dart';
import 'package:bookmywod_admin/shared/show_snackbar.dart';
import 'package:bookmywod_admin/utils/shared_preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/events/auth_event_facebook_signin.dart';
import '../../bloc/events/auth_event_should_register.dart';
import '../../bloc/events/auth_event_signin_with_google.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool rememberMe = false;
  final SupabaseClient supabase = Supabase.Supabase.instance.client;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSaveCredentials();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSaveCredentials() async {
    final savedEmail = await SharedPreferrenceHelper.getString('email');
    final savedPassword = await SharedPreferrenceHelper.getString('password');
    final savedRememberMe =
        await SharedPreferrenceHelper.getBool('remember_me') ?? false;

    if (savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        rememberMe = savedRememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await SharedPreferrenceHelper.setString('email', _emailController.text);
      await SharedPreferrenceHelper.setString(
          'password', _passwordController.text);
      await SharedPreferrenceHelper.setBool('remember_me', rememberMe);
    } else {
      await SharedPreferrenceHelper.remove('email');
      await SharedPreferrenceHelper.remove('password');
      await SharedPreferrenceHelper.remove('remember_me');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, CustomAuthState.AuthState>(
      listener: (context, state) async {
        // if (state is AuthStateLoading) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(state.message!.message)),
        //   );
        // }
        if (state is AuthStateLoggedOut) {
          await _saveCredentials();
          if (state.exception is UserNotFoundAuthException) {
            await showSnackbar(
              context,
              'User not found',
              type: SnackbarType.error,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showSnackbar(
              context,
              'Cannot find a user with the credentials',
              type: SnackbarType.error,
            );
          } else if (state.exception is GenericAuthException) {
            await showSnackbar(
              context,
              'Authentication failed',
              type: SnackbarType.error,
            );
          }
        }
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient
          ),
          child: Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.width / 24,bottom: 16,left: 16,right: 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),
                    Row(
                      children: [
                        Image.asset('assets/logo.png',height: 50,),
                        SizedBox(width: 10,),
                        Image.asset('assets/logo_name.png',),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Welcome back! Log in to continue',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.050),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: customLightBlue,
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                            color: Color(0xff1A2D40),
                            width: 1.5), // Border for the field
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12), // Add some padding inside
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.mail), // Icon
                          SizedBox(width: 8), // Space between icon and divider
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey), // Divider
                          SizedBox(
                              width: 8), // Space between divider and input field
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email can't be empty";
                                } else if (!emailValid.hasMatch(value)) {
                                  return "Invalid email provided";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white), // Input text color
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                    color:customTextColor), // Placeholder color
                                border: InputBorder.none, // Remove default border
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: customLightBlue,
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                            color: customDarkBlue,
                            width: 1.5), // Border for the field
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12), // Inner padding
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.lock_password), // Lock icon
                          SizedBox(width: 8), // Space between icon and divider
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey), // Divider
                          SizedBox(
                              width: 8), // Space between divider and input field
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText:
                                  !_isPasswordVisible, // Toggle visibility
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white), // Input text color
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color:
                                        customTextColor), // Placeholder color
                                border: InputBorder.none, // Remove default border
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CupertinoCheckbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                          checkColor: Colors.black,
                          // activeColor: Colors.white, // Tick color
                          fillColor: WidgetStateProperty.all(
                              customWhite), // Background color
                          shape: CircleBorder(), // Makes it circular
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(
                              color: customTextColor), // Adjust text color
                        ),
                        Spacer(), // Pushes "Forgot Password" to the right
                        Text(
                          'Forgot Password',
                          style:
                              TextStyle(color: customWhite), // Adjust text color
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Sign In',
                      fontSize: 16,
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            // Trigger Bloc event for authentication
                            context.read<AuthBloc>().add(AuthEventLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ));
                          } catch (e) {
                            print("Error: $e");
                          }
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            isLoading = false;
                          });
                          // final email = _emailController.text;
                          // final password = _passwordController.text;
                          // context.read<AuthBloc>().add(AuthEventLogin(
                          //     email: email, password: password));
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(child: Text('or', style: TextStyle(fontSize: 25))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton('assets/auth/google.svg', (){
                          context.read<AuthBloc>().add(
                            AuthEventSignInWithGoogle(),
                          );
                        }),
                        SizedBox(width: 20,),
                        _buildSocialButton('assets/auth/facebook.svg', () {
                          context.read<AuthBloc>().add(
                            AuthEventSignInWithFacebook(),
                          );
                        }),
                        if(Platform.isIOS)
                        _buildSocialButton('assets/auth/apple.svg', () {}),
                      ],
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have any account? ",
                            style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(AuthEventShouldRegister());
                          },
                          child: Text('Sign Up',
                              style: TextStyle(color: customBlue, fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return Container(
      width: 65,
      height: 65,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(shape:BoxShape.circle,color: customDarkBlue),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(assetPath, width: 50, height:50),
      ),
    );
  }
}
