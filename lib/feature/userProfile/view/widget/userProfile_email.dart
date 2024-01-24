

part of '../userProfile_view.dart';

class _UserProfileEmail extends StatelessWidget {
  const _UserProfileEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: Container(width: MediaQuery.of(context).size.width*0.1,
                    height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.mail,color: Colors.black,)),
                    title: AppText.appText(context.watch<UserProfileViewProvider>().currentUser.email,15,Colors.black,FontWeight.normal),//Text(_currentUser.email),
                    );
  }
}