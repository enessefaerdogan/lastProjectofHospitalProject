

part of '../signin_view.dart';

class _SigninEmailTextFF extends StatelessWidget {
  TextEditingController mailController;
  _SigninEmailTextFF({super.key , required this.mailController});

  @override
  Widget build(BuildContext context) {
    return Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        child: TextFormField(
                          decoration: InputDecoration(
                            //hintText: 'hint eklenecek',
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
                ),prefixIcon: Icon(Icons.mail_outline)),
      
                
                          controller: mailController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'E-mail zorunludur';
                            }
                            String pattern = r'\w+@\w+\.\w+';
                            RegExp regex = RegExp(pattern);
                            if(!regex.hasMatch(value)){
                              return 'Geçersiz E-mail formatı';
                            }
                            
                          },
                        ),
                      );
  }
}