import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../providers/product.dart';
import '../providers/products.dart';
class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  final _imageUrlController=TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _form=GlobalKey<FormState>();
  var _editedProduct=Product(
    id: null, 
    title: '', 
    description: '', 
    imageUrl: '', 
    price: 0,
    );
  var _initValues={
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };  
  var _isInit=true;
  var isLoading=false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
     final productId = ModalRoute.of(context).settings.arguments;
     if(productId!=null){
        _editedProduct=Provider.of<Products>(context,listen: false).findById(productId);
     _initValues={
       'title':_editedProduct.title,
       'description':_editedProduct.description,
       'price':_editedProduct.price.toString(),
      //  'imageUrl':_editedProduct.imageUrl,
      'imageUrl':'',
     };
     _imageUrlController.text=_editedProduct.imageUrl;
     }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }
  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus){
      if(_imageUrlController.text.isEmpty||
                        (!_imageUrlController.text.startsWith('http')&&!_imageUrlController.text.startsWith('https'))||
                        (!_imageUrlController.text.endsWith(".png")&&!_imageUrlController.text.endsWith(".jpg")&&!_imageUrlController.text.endsWith(".jpeg"))){
                          return;
                        }
      setState(() {});
    }
  }
  Future<void> _saveForm() async{
    final isValid=_form.currentState.validate();
    if(!isValid){
      return ;
    }
    _form.currentState.save();
    setState(() {
      isLoading=true;
    });
    if(_editedProduct.id!=null){
      try{
        await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id,_editedProduct);
      }
      catch(error){
         await showDialog(
          context: context,
          builder: (ctx){
            return AlertDialog(
              content: Text("Something Went Wrong"),
              title: Text("Error Occured???"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, 
                  child: Text("Okay"),
                )
              ],
            );
          }
        );
      }
      finally{
        setState(() {
        isLoading=false;
        });
        Navigator.of(context).pop();
      }
    }
    else{
      try{
        await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
      }
      catch(error){
        await showDialog(
          context: context,
          builder:(ctx){
            return
            AlertDialog(
              content: Text("Something Went Wrong"),
              title: Text("An Error Occoured"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(ctx).pop();
                  }, 
                  child: Text("Okay")
                ),
              ],
            );
          } 
        );
      }
      finally {
        setState(() {
          isLoading=false;
        });
        Navigator.of(context).pop();
      }
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.save),
            onPressed: _saveForm,
            ),
        ],
      ),
      body:isLoading ?Container(
        child: Center(child: CircularProgressIndicator()),
      ) 
      :Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                }, 
                validator: (value){
                  if(value.isEmpty){
                    return 'Please Provide a Valid value';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite, 
                    title: value, 
                    description: _editedProduct.description, 
                    imageUrl: _editedProduct.imageUrl, 
                  price: _editedProduct.price);
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator:(value){
                  if(value.isEmpty){
                    return 'Please Enter A Price';
                  }
                  if(double.tryParse(value)==null){
                    return 'Please Enter a Valid Number';
                  }
                  if(double.parse(value)<=0){
                    return "Please Enter A Number Greater Than Zero";
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite, 
                    title: _editedProduct.title,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                  );
                },
                
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                 onSaved: (value){
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite, 
                    title: _editedProduct.title, 
                    description: value, 
                    imageUrl: _editedProduct.imageUrl, 
                    price: _editedProduct.price,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "please enter a valid description";
                  }
                  if(value.length<10){
                    return "Should be at least 10 characters long";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height:100,
                    width:100,
                    margin:EdgeInsets.only(top:8,right:10),
                    decoration: BoxDecoration(
                      border:Border.all(width: 1,color:Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty?
                    Text("Enter A Url"):
                    FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                      decoration:InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType:TextInputType.url,
                      textInputAction:TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                      validator: (value){
                        
                        return null;
                      },
                      onSaved: (value){
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,  
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    imageUrl: value, 
                    price: _editedProduct.price,
                  );
                },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}