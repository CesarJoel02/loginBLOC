import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inicio_de_sesion_bloc/src/Providers/productos_provider.dart';
import 'package:inicio_de_sesion_bloc/src/Utils/Utils.dart' as utils;
import 'package:inicio_de_sesion_bloc/src/models/producto_model.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  


  ProductoModel producto = new ProductoModel();
  final productoprovider = new ProductosProvider();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
  if (prodData != null){
    producto = prodData;
  }

    return Container(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Producto'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value)=>producto.titulo = value,
      validator: (value){
        if (value.length < 3){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },
    );

  }

  Widget _crearPrecio(){
     return TextFormField(
       initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true,),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value)=>producto.valor = double.parse(value),
      validator: (value){

         if (utils.isNumeric(value)  ) {
           return null; 
         }else{
           return 'Sólo números';
         }

      },
    );
  }

  Widget _crearBoton(){

    return RaisedButton.icon(
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
      label: Text('Guardar'),
      color: Colors.deepPurple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }


  Widget _crearDisponible(){

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );

  }


  void _submit()async {
    if(!formKey.currentState.validate()) return;


    formKey.currentState.save();
    
    setState(() {_guardando = true;});

    if (foto != null){
      producto.fotoUrl = await productoprovider.subirImagen(foto);
    }


    if(producto.id == null){
       productoprovider.crearProducto(producto);
    }else{
       productoprovider.editarProducto(producto);
    }
    // setState(() {_guardando = false;});
    mostrarSnackbar('Registro Guardado');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500,),
    );
   scaffoldKey.currentState.showSnackBar(snackbar); 
  }

  _mostrarFoto(){

    if(producto.fotoUrl != null){
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,

      );
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );

    }

  }

  _seleccionarFoto () async {

  _procesarFoto(ImageSource.gallery);

  }

  _tomarFoto()async{

   _procesarFoto(ImageSource.camera);

  }


  _procesarFoto(  ImageSource origen  )async {


       foto = await ImagePicker.pickImage(
      source: origen,
    );

    if (foto != null ){
      producto.fotoUrl = null;
    } 

    setState(() {});


  }

}