

part of '../onboard_view.dart';

class _OnboardButton extends StatelessWidget {
  const _OnboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),onPressed: (){
                    
                   /* if(service.containsKey(key: "onboard1") == false){
                      //MyStatic.isContains = true; 
                      //print("Anlık değer:" + MyStatic.isContains.toString());
                    service.createString(key: "onboard1",value: "1");
                    }
              
                    else{
                      print("PRİNT:"+service.containsKey(key: "onboard1").toString());
                      //MyStatic.isContains = false;
                      print("BABA BUNE");
                    }*/
              
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SigninView()));
                }, child: Text("Başla",style: TextStyle(fontFamily: 'Open Sans',fontSize: 20),)),
              ),
            );
  }
}