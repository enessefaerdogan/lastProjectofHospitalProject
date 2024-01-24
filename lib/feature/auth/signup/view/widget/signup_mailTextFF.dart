


part of '../signup_view.dart';

class _SignupMailTextFF extends StatelessWidget {
  TextEditingController mailController;
  _SignupMailTextFF({required this.mailController});

  @override
  Widget build(BuildContext context) {
    return Container(
                      width: MediaQuery.of(context).size.width*0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
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
                        },
                      ),
                    );
  }
}