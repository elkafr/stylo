import 'package:flutter/material.dart';
import 'package:stylo/models/category.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
    final AnimationController animationController;
  final Animation animation;

  const CategoryItem({Key key, this.category, this.animationController, this.animation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(

            margin: EdgeInsets.only(top: constraints.maxHeight *0.05),
            width: constraints.maxWidth *0.7,
            height: constraints.maxHeight *0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: category.isSelected ? mainAppColor: Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
            ),
            child:  category.catId != '0' ?
            ClipRRect(
    borderRadius: BorderRadius.all( Radius.circular(50.0)),
    child: Image.network(category.catImage,fit: BoxFit.contain,width: 35,height: 35)) :
            Image.asset(category.catImage),
          ),
          Container(
            alignment: Alignment.center,
            width: constraints.maxWidth,
            child: Text(category.catName,style: TextStyle(

              color: category.isSelected ?mainAppColor:Colors.black,fontSize: category.catName.length > 1 ?13 : 13,

            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,),
          ),

        ],
      );
    });
  }
}
