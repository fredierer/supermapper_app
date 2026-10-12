import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/map.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _addSpotScreenState();

}
class _addSpotScreenState extends State<AddSpotScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(),
        SafeArea(
          child : Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0, vertical: 0.0),
            child : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back_ios_new_outlined, size: 24,),
                ),
                Text("Choose location",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {}, 
                  label: Text("Next"), 
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            )
          )
        ),
        Center(child: Text("📍", style: TextStyle(fontSize: 28),),)
      ],
    );

  }
}