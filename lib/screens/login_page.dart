import 'package:flutter/material.dart';
import 'package:persoal_finance/services/auth_services.dart';
import 'package:persoal_finance/widgets/app_button.dart';
import 'package:persoal_finance/widgets/app_text.dart';
import 'package:persoal_finance/widgets/customtextformfiled.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _loginKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child:
        Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/logo.png'),
              SizedBox(height: 80,),

              CustomTextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Email is mandatory";
                  }return null;
                },
                controller: _emailController,
                hintText: 'Email',
              ),

              const SizedBox(height: 20,),

              CustomTextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Password is mandatory";
                  }return null;
                },
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 20,),

              AppButton(
                onTap: () async {

                  if(_loginKey.currentState!.validate()){

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });

                  final user=await  authService.loginUser(_emailController.text.trim(), _passwordController.text.trim());
                    Navigator.pop(context);
                  if(user!=null){
                    Navigator.pushNamedAndRemoveUntil(context, 'home', (route)=> false);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('No user exist') ,
                      ),
                    );
                  }
                  }

                },
                child: Text('Login'),
                color: Colors.blueAccent,
                height: 50,
                width: 140,
              ),
              const SizedBox(height: 30,),

              Row(
                children: [
                  AppText(data: "Don't have an account?", color: Colors.white,),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, 'register');
                    },
                    child:
                      AppText(data: "Register", color: Colors.white,))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
