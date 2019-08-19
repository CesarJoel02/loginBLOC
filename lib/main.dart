import 'package:flutter/material.dart';
import 'package:inicio_de_sesion_bloc/src/Preferencias_Usuario/preferencias_usuario.dart';
import 'package:inicio_de_sesion_bloc/src/bloc/provider.dart';
import 'package:inicio_de_sesion_bloc/src/pages/home_page.dart';
import 'package:inicio_de_sesion_bloc/src/pages/login_page.dart';
import 'package:inicio_de_sesion_bloc/src/pages/producto_page.dart';
import 'package:inicio_de_sesion_bloc/src/pages/registro_page.dart';
 
void main() async {
    
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();


    runApp(MyApp());
  }
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();  
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'     : (BuildContext context)  => LoginPage(),
          'registro'  : (BuildContext context)  => RegistroPage(),
          'home'      : (BuildContext context)  => HomePage(),
          'producto'  : (BuildContext context)  => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
      
    );
  }
}