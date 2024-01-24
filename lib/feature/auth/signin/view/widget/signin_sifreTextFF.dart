

part of '../signin_view.dart';

class _SigninSifreTextFF extends StatefulWidget {
  TextEditingController sifreController;
  _SigninSifreTextFF({super.key, required this.sifreController});

  @override
  State<_SigninSifreTextFF> createState() => _SigninSifreTextFFState();
}

class _SigninSifreTextFFState extends State<_SigninSifreTextFF> {
bool _showPass = true;

void changeShowPass(){
  setState(() {
        _showPass = !_showPass;
  });

   // notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        child: TextFormField(
                          obscureText: _showPass,
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
                  
                  changeShowPass();
                   
                }, icon: Icon(_showPass ==true ? Icons.visibility_off : Icons.visibility))),
                
                          controller: widget.sifreController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Şifre zorunludur';
                            }
                          },
                        ),
                      );
  }
}