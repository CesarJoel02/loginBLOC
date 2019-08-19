import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:inicio_de_sesion_bloc/src/Preferencias_Usuario/preferencias_usuario.dart';
import 'package:inicio_de_sesion_bloc/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider{
final String _url = 'https://pruebasudemy-7c208.firebaseio.com';
final _prefs = new PreferenciasUsuario();


  Future<bool> crearProducto (ProductoModel producto) async{

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(producto));


    final decodeData = json.decode(resp.body);

    print (decodeData);
    return true; 
  }

  Future<bool> editarProducto (ProductoModel producto) async{

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(producto));


    final decodeData = json.decode(resp.body);

    print (decodeData);
    return true; 
  }

  Future<List<ProductoModel>> cargarProductos() async {

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic>decodedData = json.decode(resp.body);
    final List<ProductoModel>productos = new List(); 

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod){

      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;


      productos.add(prodTemp);

    });

    // print(productos[0].id);
    return productos;
  }

  Future<int> brrarProducto (String id) async{

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;

  }

  Future <String> subirImagen(File imagen) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dajwxacur/image/upload?upload_preset=frr0xssm');
    final mimeType = mime(imagen.path).split('/');

    final imageuploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
        imagen.path,
        contentType: MediaType(
          mimeType[0], 
          mimeType[1]
          )
      );

    imageuploadRequest.files.add(file);

    final streamResponse = await imageuploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo Salio mal');
      print(resp.statusCode);
      print(resp.request);
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];



  }
}


