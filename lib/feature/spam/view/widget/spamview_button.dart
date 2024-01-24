

part of '../spam_view.dart';

class _SpamViewButton extends StatelessWidget {
  AppUser currentUser;
  Review currentReview;
  _SpamViewButton(
    {
      required this.currentUser,
      required this.currentReview
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.getHeight*0.33),
                  width: MediaQuery.of(context).size.width*0.85,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),onPressed: ()async {

                      // gönderici metod
                      //sendBildir();
                      context.read<SpamViewProvider>().sendBildir(currentUser, currentReview);
                      ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(InfoSnackbar.infoSnackbar("Bildiri Yapıldı!", "Bildiriniz ve ilgili yorum incelemeye alınmıştır.", Duration(seconds: 2)));
                      Navigator.pop(context);
                    
                  }, child: Text("Onayla",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17),)),
    );
  }
}