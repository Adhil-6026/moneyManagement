import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final String textOne;
  final String textTwo;

  const DashboardWidget({super.key, required this.onTap1, required this.textOne, required this.onTap2, required this.textTwo});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red, Colors.teal]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(height: 20, width: 5, color: Colors.orange,),
            top: 30,
            left: 0,
            bottom: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkResponse(
                  onTap: onTap1,
                  child: Center(child: Text(textOne, style: TextStyle(fontSize: 15),),),
                ),
              ),
              Container(
                height: 80,
                width: 2,
                color: Colors.orange,
              ),
              Expanded(
                child: InkResponse(
                  onTap: onTap2,
                  child: Center(child: Text(textTwo, style: TextStyle(fontSize: 15),),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
