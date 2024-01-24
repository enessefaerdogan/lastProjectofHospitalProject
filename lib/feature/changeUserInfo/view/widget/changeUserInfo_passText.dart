


part of '../changeUserInfo_view.dart';

class _ChangeUserInfoPassText extends StatelessWidget {
  TextEditingController passController;
  AppUser currentUser;
  _ChangeUserInfoPassText(
    {
      required this.passController,
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
                            hintText: currentUser.sifre,
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
                ),prefixIcon: Icon(Icons.password)),
                
                          controller: passController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Yeni Şifre girilmelidir';
                            }
                            
                            if(value.length<6){
                              return 'Şifre en az 6 hane olmalıdır';
                            }
                          },
                        ),
                      );
  }
}