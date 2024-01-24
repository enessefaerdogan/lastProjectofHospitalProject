

part of '../userProfile_view.dart';

class _UserProfileSifre extends StatelessWidget {
  const _UserProfileSifre({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: Container(width: MediaQuery.of(context).size.width*0.1,
                    height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.password,color: Colors.black,)),
                    title: AppText.appText(context.watch<UserProfileViewProvider>().turnedAppUser.sifre!= "sifre" ? context.watch<UserProfileViewProvider>().turnedAppUser.sifre : context.watch<UserProfileViewProvider>().currentUser.sifre,15,Colors.black,FontWeight.normal),//Text(turnedAppUser.sifre!= "sifre" ? turnedAppUser.sifre : _currentUser.sifre),
                    trailing: Icon(Icons.chevron_right,color: Colors.black,),
                    onTap: ()async{
                     
                     context.read<UserProfileViewProvider>().turnedAppUserMethodSifre(context);
                     
                    },);
  }
}