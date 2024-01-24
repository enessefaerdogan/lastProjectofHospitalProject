


part of '../changeUserInfo_view.dart';

class _ChangeUserInfoTcText extends StatelessWidget {
  TextEditingController tcController;
  AppUser currentUser;
  _ChangeUserInfoTcText(
    {
      required this.tcController,
      required this.currentUser
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: TextFormField(
                          maxLength: 11,
                          decoration: InputDecoration(
                            //label: Text("E-mail"),
                            hintText: currentUser.tc,
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
                ),prefixIcon: Icon(Icons.person)),
                
                          controller: tcController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Yeni TC girilmelidir';
                            }
                            
                            if(value.length != 11){
                              return 'TC No 11 haneli olmalıdır';
                            }
                          },
                        ),
                      );
  }
}