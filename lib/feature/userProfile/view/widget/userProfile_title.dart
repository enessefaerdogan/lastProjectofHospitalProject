

part of '../userProfile_view.dart';

class _UserProfileTitle extends StatelessWidget {
  const _UserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.015),
                          child: ListTile(
                          leading: Container(width: MediaQuery.of(context).size.width*0.1,
                          height: MediaQuery.of(context).size.height*0.05,child: Image.asset("assets/user.png")),
                          title: AppText.appText((context.watch<UserProfileViewProvider>().turnedAppUser.ad!= "ad" ? context.watch<UserProfileViewProvider>().turnedAppUser.ad : context.read<UserProfileViewProvider>().currentUser.ad) +" "+(context.watch<UserProfileViewProvider>().turnedAppUser.soyad!= "soyad" ? context.watch<UserProfileViewProvider>().turnedAppUser.soyad : context.watch<UserProfileViewProvider>().currentUser.soyad), 17, Colors.black,FontWeight.normal)), //Text(_currentUser.ad+" "+_currentUser.soyad),),
                        );
  }
}