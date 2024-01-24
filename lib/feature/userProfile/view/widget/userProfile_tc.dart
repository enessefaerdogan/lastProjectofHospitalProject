

part of '../userProfile_view.dart';

class _UserProfileTc extends StatelessWidget {
  const _UserProfileTc({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: Container(width: MediaQuery.of(context).size.width*0.1,
                    height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.person,color: Colors.black,)),
                    title: AppText.appText(context.watch<UserProfileViewProvider>().turnedAppUser.tc!= "tc" ? context.watch<UserProfileViewProvider>().turnedAppUser.tc : context.watch<UserProfileViewProvider>().currentUser.tc,15,Colors.black,FontWeight.normal),//Text(turnedAppUser.tc!= "tc" ? turnedAppUser.tc : _currentUser.tc),
                    trailing: Icon(Icons.chevron_right,color: Colors.black,),
                    onTap: ()async{
                     context.read<UserProfileViewProvider>().turnedAppUserMethodTC(context);
                       },);
  }
}