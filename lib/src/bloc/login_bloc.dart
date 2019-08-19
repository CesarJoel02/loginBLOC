import 'dart:async';
import 'package:inicio_de_sesion_bloc/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with validators{

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validaremail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarpassword);

  Stream<bool> get formValidStream => 
      Observable.combineLatest2(emailStream, passwordStream, (e,p) => true);


  //Insertar valores al Stream
  Function(String) get changeEmail     => _emailController.sink.add;
  Function(String) get changePassword  => _passwordController.sink.add;

  //get y set

  String get email      => _emailController.value;
  String get password   => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

  
}