

part of '../signup_view.dart';

class _SignupSifreTextFF extends StatelessWidget {
  TextEditingController sifreController;
  _SignupSifreTextFF(
    {
    required this.sifreController
      
    }
    );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                      width: MediaQuery.of(context).size.width*0.85,
                      child: TextFormField(
                        obscureText: context.read<SignupViewProvider>().showPass,
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
              ),prefixIcon: Icon(Icons.password_rounded),
              suffixIcon: IconButton(onPressed: (){
                context.read<SignupViewProvider>().changeShowPass();
              }, icon: Icon(context.watch<SignupViewProvider>().showPass==true ? Icons.visibility_off : Icons.visibility))),
              
                        controller: sifreController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Şifre zorunludur';
                          }
                        },
                      ),
                    );
  }
}