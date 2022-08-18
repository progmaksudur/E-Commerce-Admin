import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:e_commerce_app_admin/provider/order_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_const_model.dart';
import '../utlitis/helper_functions.dart';

class SettingPage extends StatefulWidget {
  static const String routeName="/setting";
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AppHelperProvider productProvider;
  late OrderProvider orderProvider;
  double deliveryChargeSliderValue = 0;
  double discountSliderValue = 0;
  double vatSliderValue = 0;
  bool needUpdate = false;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<AppHelperProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getOrderConstants().then((value) {
      setState(() {
        deliveryChargeSliderValue = orderProvider.orderConstantsModel.deliveryCharge.toDouble();
        discountSliderValue = orderProvider.orderConstantsModel.discount.toDouble();
        vatSliderValue = orderProvider.orderConstantsModel.vat.toDouble();
      });
    });


    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            elevation: 5,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Delivery Charge"),
                    trailing: Container(
                        width: 35,
                        child: Container(
                            width: 35,
                            child: Text("৳${deliveryChargeSliderValue.round()}"))),
                    subtitle: Slider(
                      value: deliveryChargeSliderValue.toDouble(),
                      min: 0,
                      max: 500,
                      divisions: 50,
                      label: deliveryChargeSliderValue.toStringAsFixed(0),
                      onChanged: (double value) {
                        setState(() {
                          deliveryChargeSliderValue = value;
                          _checkUpdate();
                        });
                      },
                    ),
                  ),

                  Divider(),

                  ListTile(
                    title: Text("Discount"),
                    trailing: Container(
                        width: 35,
                        child: Text("${discountSliderValue.round()}%")),
                    subtitle: Slider(
                      value: discountSliderValue.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: discountSliderValue.toStringAsFixed(0),
                      onChanged: (double value) {
                        setState(() {
                          discountSliderValue = value;
                          _checkUpdate();
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Vat"),
                    trailing: Container(
                        width: 35,
                        child: Text("৳${vatSliderValue.round()}")),
                    subtitle: Slider(
                      value: vatSliderValue.toDouble(),
                      min: 0,
                      max: 150,
                      divisions: 150,
                      label: vatSliderValue.toStringAsFixed(0),
                      onChanged: (double value) {
                        setState(() {
                          vatSliderValue = value;
                          _checkUpdate();
                        });
                      },
                    ),
                  ),
                  Divider(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(
                            color: needUpdate? Theme.of(context).primaryColor: Colors.grey)),
                    onPressed: needUpdate ? () {

                      final model = OrderConstantsModel(
                        deliveryCharge: deliveryChargeSliderValue,
                        discount: discountSliderValue,
                        vat: vatSliderValue,
                      );
                      orderProvider.addOrderConstants(model).then((value) {
                        showMsg(context, 'Updated');
                        setState((){
                          needUpdate = false;
                        });
                      });

                    }:null,
                    child: const Text(' Update '),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkUpdate() {
    needUpdate =
        deliveryChargeSliderValue != orderProvider.orderConstantsModel.deliveryCharge.toDouble() ||
            discountSliderValue != orderProvider.orderConstantsModel.discount.toDouble() ||
            vatSliderValue != orderProvider.orderConstantsModel.vat.toDouble();
  }
}
