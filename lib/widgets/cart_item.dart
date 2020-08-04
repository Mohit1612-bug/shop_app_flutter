

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItem({
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.productId,
  });
  @override
  Widget build(BuildContext context) {
    final cartData =Provider.of<Cart>(context,listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color:Theme.of(context).errorColor,
        child: Icon(Icons.delete,size:40,color:Colors.white),
        alignment: Alignment.centerRight,
        padding:EdgeInsets.only(right:20),
        margin: EdgeInsets.symmetric(horizontal:15,vertical:4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        cartData.removeId(productId);
      },
      confirmDismiss: (direction){
        return showDialog(
          context:context,
          builder: (_)=>AlertDialog(
            title: Text("Are You Sure?"),
            content:Text("do you want to remove item??"),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                }, 
                child: Text("No"),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                  
                }, 
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
        child: Card(
        margin: EdgeInsets.symmetric(horizontal:15,vertical:4),
        child:Padding(
          padding: EdgeInsets.all(8),
          child:ListTile(
            leading: CircleAvatar(
              child:Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text("\$$price"),
              ),
            ),
            ),
            title: Text(title),
            subtitle: Text("Total: \$${(price *quantity)}"),
            trailing:Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}