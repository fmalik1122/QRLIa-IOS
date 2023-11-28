import 'package:flutter/material.dart';

import '../SDP.dart';
import '../utils/controls.dart';
import 'ViewStatusScreen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {

  Size? _size;

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title:  Text(
            'Add Story',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(0), right: SDP.sdp(0)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  StatusItemModel statusItemModel = StatusHelper.getStatusItem(position);
                  if(position == 0){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.green,
                                    width: 2
                                )
                            ),
                            child:  CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(statusItemModel.image),
                            ),
                          ),
                          title:  Text(
                            statusItemModel.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            statusItemModel.name+", "+statusItemModel.dateTime,
                            style: Theme.of(context).textTheme.bodyText1,
                          ) ,
                        ),
                        const Divider(),
                      ],
                    );
                  }else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10 , bottom: 5 , left: 20 ),
                          child: Text('View Updates' , style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => MoreStories()));
                          },
                          child: ListTile(
                            leading:  CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(statusItemModel.image),
                            ),
                            title:  Text(
                              statusItemModel.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            subtitle: Text(
                              statusItemModel.name+", "+statusItemModel.dateTime,
                              style: Theme.of(context).textTheme.bodyText1,
                            ) ,
                          ),
                        ),
                        const Divider(),
                      ],
                    );

                  }
                },
                itemCount: StatusHelper.itemCount,
              ),
            ),

          ],
        ),
      )
    );
  }
}

class StatusHelper {

  static var statusList = [
    StatusItemModel("John Snow", "Yesterday, 21:22 PM" , "https://cdn.pixabay.com/photo/2016/11/21/14/53/man-1845814_960_720.jpg"),
    StatusItemModel("GOT", "Yesterday, 09:09 PM" , "https://cdn.pixabay.com/photo/2015/01/06/16/14/woman-590490_960_720.jpg")
  ];

  static StatusItemModel getStatusItem(int position) {
    return statusList[position];
  }

  static var itemCount = statusList.length;

}

class StatusItemModel {

  String name;
  String dateTime;
  String image;

  StatusItemModel(this.name, this.dateTime , this.image );

}