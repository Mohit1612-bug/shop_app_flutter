import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id,this.title,this.imageUrl);
  // Future<void>onDelete() async{

  // }

  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing:Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit), 
            onPressed: (){
              Navigator.of(context).pushNamed('/edit-products-screen',arguments: id);
            },
            color:Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: ()async{
              try{
                await Provider.of<Products>(context,listen: false).deleteProduct(id);
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text("Item has been deleted"),
                    duration: Duration(seconds: 2),
                  )
                );
              }
              catch(error){
                scaffold.showSnackBar(
                SnackBar(
                  content: Text("Deleting Item failed"),
                  duration: Duration(seconds:2)
                ),
              );
              }
            },
            color:Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}