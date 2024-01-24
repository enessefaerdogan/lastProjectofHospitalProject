

part of '../userProfile_view.dart';

class _UserProfileSoyad extends StatelessWidget {
  const _UserProfileSoyad({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: Container(width: MediaQuery.of(context).size.width*0.1,
                    height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.info,color: Colors.black,)),
                    title: AppText.appText(context.watch<UserProfileViewProvider>().turnedAppUser.soyad!= "soyad" ? context.watch<UserProfileViewProvider>().turnedAppUser.soyad : context.watch<UserProfileViewProvider>().currentUser.soyad,15,Colors.black,FontWeight.normal),//Text(turnedAppUser.soyad!= "soyad" ? turnedAppUser.soyad : _currentUser.soyad),
                    trailing: Icon(Icons.chevron_right,color: Colors.black,),
                    onTap: ()async{
                     context.read<UserProfileViewProvider>().turnedAppUserMethodSoyad(context);                   
                    },);
  }
}