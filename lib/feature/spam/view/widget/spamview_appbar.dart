

part of '../spam_view.dart';

class _SpamViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SpamViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: Colors.red,
      title: Text("Bildir",style:TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),leading: IconButton(onPressed: (){

          Navigator.pop(context);

      }, icon: Icon(Icons.chevron_left,color: Colors.white,)),);
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}