

part of '../changeUserInfo_view.dart';

class _ChangeUserInfoAdText extends StatelessWidget {
  TextEditingController adController;
  AppUser currentUser;
  _ChangeUserInfoAdText(
    {
      required this.adController,
      required this.currentUser
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            //label: Text("E-mail"),
                            hintText: currentUser.ad,
                            enabledBorder: OutlineInputBorder(
                              
                  borderSide:
              BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(20.0),
            
                  
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
            color: Colors.black,
            width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
            color: Colors.redAccent,
            width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),prefixIcon: Icon(Icons.info)),
                
                          controller: adController,
                          validator: (value){

                            if(value == null || value.isEmpty){
                              return 'Yeni Ad girilmelidir';
                            }
                            
                          },
                        ),
                      );
  }
}