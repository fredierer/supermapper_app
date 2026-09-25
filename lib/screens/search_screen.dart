import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _searchScreenState();

}

class _searchScreenState extends State<SearchScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
          child : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 24,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20),
                  Expanded(child: 
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Seoul restaurant, ...',
                        border: OutlineInputBorder(),
                      ),
                    )
                  ,)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: Text("Result 1"),
                  ),
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: Text("Result 2"),
                  ),
                ],

              )
            ]
          )
        )
      )
    );
  }

}