import 'package:covidtracker/size_config/size_config.dart';
import 'package:covidtracker/widget/3dCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


CustomCard({color, text, number}){
  return Container(
    height: SizeConfig.blockSizeVertical*13,
    child: HoverCard(
      builder: (context, hovering){
        return Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          height: SizeConfig.blockSizeVertical*13,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color:  Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  number,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22
                  ),
                ),
              )
            ],
          ),
        );
      },
      depth: 10,
      depthColor: color.withOpacity(0.7),
      onTap: (){},
      shadow: BoxShadow(
        color: Colors.transparent,
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ),
  );
}