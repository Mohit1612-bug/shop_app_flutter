import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
     
    
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
      _isLoading = true;
    });
    try{
      await Provider.of<Orders>(context,listen:false).fetchAndSetOrders();
    }
    catch(error){
     await showDialog(
       context: context,
       builder: (ctx){
         return AlertDialog(
           content: Text("Something Went Wrong"),
              title: Text("An Error Occoured"),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                     Navigator.of(ctx).pushReplacementNamed('/');
                  }, 
                  child: Text("Okay")
                ),
              ],
         );
       }
     );
    }
      
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
       appBar: AppBar(
         title:Text("Your Orders"),
       ), 
       drawer: AppDrawer(),
       body:_isLoading?Center(child: CircularProgressIndicator(),): ListView.builder(
         itemBuilder: (context,index) =>OrderItem(
           orderData.orders[index],
           ),
         itemCount: orderData.orders.length,
       )
    );
  }
}