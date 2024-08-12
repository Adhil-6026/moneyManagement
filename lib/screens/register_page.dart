import 'package:flutter/material.dart';
import 'package:persoal_finance/models/user_model.dart';
import 'package:persoal_finance/services/auth_services.dart';
import 'package:persoal_finance/widgets/app_button.dart';
import 'package:persoal_finance/widgets/app_text.dart';
import 'package:persoal_finance/widgets/customtextformfiled.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _registerEmail = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();

    final _regKey = GlobalKey<FormState>();

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Form(
          key: _regKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    AppText(
                      data: "Create an account",
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is mandatory";
                        }
                        return null;
                      },
                      controller: _nameController,
                      hintText: "Name",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone is mandatory";
                        }
                        return null;
                      },
                      controller: _phoneController,
                      hintText: "Phone",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email is mandatory";
                          }
                          return null;
                        },
                        controller: _registerEmail,
                        hintText: "Email"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is mandatory";
                        }
                        if (value.length < 8) {
                          return "Password at least 8 characters or more";
                        }
                        return null;
                      },
                      obscureText: true,
                      controller: _passwordController,
                      hintText: "Password",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      onTap: () async{
                        var uuid = Uuid().v1();
                        if (_regKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              );
                          UserModel user = UserModel(
                            email: _registerEmail.text.trim(),
                            password: _passwordController.text.trim(),
                            name: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                            status: 1,
                            id: uuid,
                          );

                          final res = await authService.registerUser(user);
                          Navigator.pop(context);
                          if(res==true){
                            Navigator.pop(context);
                          }

                        }
                      },
                      color: Colors.blueAccent,
                      height: 50,
                      width: 140,
                      child: AppText(
                        data: "Register",
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        AppText(
                          data: "Already have an account?",
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: AppText(
                            data: "Login",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
