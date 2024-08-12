import 'package:flutter/material.dart';
import 'package:persoal_finance/services/auth_services.dart';
import 'package:persoal_finance/widgets/app_button.dart';
import 'package:persoal_finance/widgets/app_text.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: AppText(data: 'Profile'),),
      body: Center(
        child: FutureBuilder(
          future: authService.getCurrentUser(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }else{
              if(snapshot.hasData){
                final user = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    const SizedBox(height: 20,),
                    AppText(data: 'Name: ${user.name}', color: Colors.white,),
                    const SizedBox(height: 20,),
                    AppText(data: 'Email: ${user.email}', color: Colors.white,),
                    const SizedBox(height: 20,),
                    AppText(data: 'Phone: ${user.phone}', color: Colors.white,),
                    const SizedBox(height: 20,),
                    
                    AppButton(
                      height: 50,
                      width: 200,
                      color: Colors.blueAccent,
                      onTap: ()async{
                      final data = await authService.logOut();
                      if(data==true){
                        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                      }
                    },
                      child: AppText(data: 'Logout', color: Colors.white,),
                    ),
                  ],
                );
              }else{
                return const Text('No user logged in');
              }
            }

          },
        ),
      ),
    );
  }
}
