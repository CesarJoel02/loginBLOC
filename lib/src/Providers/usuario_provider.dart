import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inicio_de_sesion_bloc/src/Preferencias_Usuario/preferencias_usuario.dart';

class UsuarioProvider{

  final String _fireBaseToken = 'AIzaSyDtn3EcNPZJSleaubKl-nGhYh8X9NcgWQw';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {

     final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_fireBaseToken',
      body: jsonEncode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')){


      _prefs.token =  decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else{
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }

  }

  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_fireBaseToken',
      body: jsonEncode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')){
      _prefs.token =  decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else{
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }

  }



}