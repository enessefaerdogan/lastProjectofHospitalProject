

part of '../changeUserInfo_view.dart';

class _ChangeUserInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? whichPart;
  _ChangeUserInfoAppBar(this.whichPart);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
           Navigator.pop(context);
           // burada popUntil yapılmalı
            //Navigator.of(context).popUntil(ModalRoute.withName('userProfile'));


        }, icon: Icon(Icons.chevron_left,color: Colors.white,)),
    title: AppText.appText(whichPart! + " düzenle", 17, Colors.white,FontWeight.normal),//Text(widget.whichPart+" düzenle",style: TextStyle(fontSize: 17,fontFamily: 'Poppins-Regular',color: Colors.white),),
    backgroundColor: Colors.red,);
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}