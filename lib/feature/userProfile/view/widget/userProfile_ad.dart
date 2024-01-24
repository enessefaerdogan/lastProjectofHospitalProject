

part of '../userProfile_view.dart';

class _UserProfileAd extends StatelessWidget {
  const _UserProfileAd({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: Container(width: MediaQuery.of(context).size.width*0.1,
                    height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.info,color: const Color.fromARGB(255, 1, 1, 1),)),
                    title: AppText.appText(context.watch<UserProfileViewProvider>().turnedAppUser.ad!= "ad" ? context.watch<UserProfileViewProvider>().turnedAppUser.ad : context.watch<UserProfileViewProvider>().currentUser.ad,15,Colors.black,FontWeight.normal),//Text(turnedAppUser.ad!= "ad" ? turnedAppUser.ad : _currentUser.ad),
                    trailing: Icon(Icons.chevron_right,color: Colors.black,),
                    onTap: ()async{
                     context.read<UserProfileViewProvider>().turnedAppUserMethodAd(context);
                    },);
  }
}