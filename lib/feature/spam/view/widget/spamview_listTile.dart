

part of '../spam_view.dart';

class _SpamViewListTile extends StatelessWidget {
  int index;
  _SpamViewListTile(
    {
      required this.index
    }
    );

  @override
  Widget build(BuildContext context) {
    return ListTile(
          onTap: (){

            context.read<SpamViewProvider>().changeOption(context.read<SpamViewProvider>().chooses[index]);
       
      },
      title: Text(context.read<SpamViewProvider>().chooses[index]),
      leading: Radio(
        value: context.read<SpamViewProvider>().chooses[index],
        groupValue: context.watch<SpamViewProvider>().selectedOption,
        onChanged: (value) {

          context.read<SpamViewProvider>().changeOption(context.read<SpamViewProvider>().chooses[index]);
   
        },
      ),
    );
  }
}