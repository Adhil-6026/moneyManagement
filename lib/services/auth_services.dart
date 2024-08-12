
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService with ChangeNotifier{

  Box<UserModel> ? _userBox;

  static const String _loggedInKey = 'isLoggedIn';

  Future<void> openBox() async{
    _userBox = await Hive.openBox('users');
  }

  //register user
  Future<bool> registerUser(UserModel user) async{
    if(_userBox==null){
      await openBox();
    }
    await _userBox!.add(user);
    notifyListeners();
    return true;
  }

  //login user
  Future<UserModel?> loginUser(String email, String password)async{
    if(_userBox==null){
      await openBox();
    }
    for(var user in _userBox!.values){
      if(user.email==email && user.password==password){
        await setLoggedIn(true, user.id);
        return user;
      }
    }
    return null;
  }

  Future<void> setLoggedIn(bool isLoggedIn, String id)async{
    final _pref= await SharedPreferences.getInstance();
    await _pref.setBool(_loggedInKey, isLoggedIn);
    await _pref.setString('id', id);
  }

  Future<bool> isUserLoggedIn()async{
    final _pref = await SharedPreferences.getInstance();
    return _pref.getBool(_loggedInKey) ?? false;
  }

  Future<UserModel?> getCurrentUser()async{
    final isLoggedIn =await isUserLoggedIn();
    if(isLoggedIn){
      final loggedUserId =await getLoggedInUserId();
      for(var user in _userBox!.values){
        if(user.id==loggedUserId){
          return user;
        }
      }
    }
    return null;
  }

  Future<String?> getLoggedInUserId()async{
    final _pref =await SharedPreferences.getInstance();
    final id =await _pref.getString('id');
    return id;
  }

  Future<bool> logOut()async{
      final _pref = await SharedPreferences.getInstance();
      await _pref.clear();
      return true;
  }

}