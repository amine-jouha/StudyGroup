import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:studygroup/profile_setting/help_support.dart';
import 'package:studygroup/profile_setting/invitation.dart';
import 'package:studygroup/profile_setting/privacy.dart';
import 'package:studygroup/profile_setting/settings.dart';
import 'login.dart';
import 'package:studygroup/model/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}
Future<bool?> showWarning(BuildContext context) async {
  return showDialog<bool>(
    context : context,
    builder : (context) => AlertDialog(
      title: Text("Warning!"),
      content: Text("Do you want to logout?!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes")),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Nop",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    ),
  );
}
// pour ramener une image précise de la base de donnée avec son nom
Future<Widget> _getImageFB(BuildContext context, String imageName) async {
  late Image image;
  await FireStorageService.loadImage(context, imageName).then((value) => {
    image = Image.network(
      value.toString(),
      fit: BoxFit.cover,
      height: 142,
      width: 130,
    ),
  });
  return image;
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    }
  List para = [
    'Privacy',
    'Settings',
    'Help & Support',
    'Invite a Friend',
  ];
  List coco = [
    LineAwesomeIcons.user_shield,
    LineAwesomeIcons.cog,
    LineAwesomeIcons.question_circle,
    LineAwesomeIcons.user_plus,
  ];

  List pg = [
    Privacy(),
    SettingsProfile(),
    Support(),
    Invitation()
  ];

  ImagePicker image = ImagePicker();
  String url = '';
  File? file;
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
      // print(file);
    });
    uploadFile();
  }

  uploadFile() async {
    var imageFile = FirebaseStorage.instance.ref().child('/${loggedInUser.uid.toString()}');
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    //for downloading
    url = await snapshot.ref.getDownloadURL();
    print(url);
    print('ici');
    print(imageFile.name);
  }





  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
// }


    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {logout(context);},
              icon: Icon(Icons.logout),
              color: Colors.white,
            ),]
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children:[
                  Center(
                    child: Container(
                      height: 130,
                      child:FutureBuilder<Widget>(
                        future: _getImageFB(context, '${loggedInUser.uid.toString()}'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                          if (snapshot.connectionState == ConnectionState.done) {
                            print('le voici');
                            print(snapshot.data);
                            return
                              ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 60,
                                child: snapshot.data,
                              ),
                            );

                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage(
                                    'assets/pp.png',
                                  )

                                ),
                            );
                          }
                          else return Container(
                            child: CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(
                                  'assets/pp.png',
                                )

                            ),
                          );
                        },
                      ),
                      // CircleAvatar(
                      //   radius: 80,
                      //   backgroundImage:
                      //   file==null
                      //       ? AssetImage(
                      //     'assets/pp.png',
                      //   ):
                      //   FileImage(File(file!.path)) as ImageProvider,
                      // ),
                    ),
                  ),
                  Align(
                    // alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async{
                        // PickedFile? selectedImage =
                        getImage();
                        print('amine le boss');
                        // File image =
                        // File(selectedImage!.path);
                        //  TOmDO: upload the image to firebase storage
                        // await locator
                        //     .get<UserController>()
                        //     .uploadProfilePicture(image);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(100, 96, 0, 0),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          heightFactor: 30,
                            widthFactor: 10,
                            child: Icon(LineAwesomeIcons.pen, color: Colors.white60,)
                        ),
                      ),
                    ),
                  ),

          ],),

              SizedBox(height: 10,),
              Text(
                '${loggedInUser.userName}'.toUpperCase(),
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                '${loggedInUser.email}',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 35,),
              Expanded(
                child: ListView.builder(
                    itemCount: para.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color:Colors.grey,
                                offset: Offset(0,0),
                                blurRadius: 5,
                              )
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Card(
                            elevation: 0,
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Icon(
                                  coco[index],

                                  // style: TextStyle(
                                  //   color: Colors.blueAccent,
                                  //   fontSize: 18,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                ),
                              ),
                              title: Text(
                                para[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              // subtitle: Text(
                              //   prepara[index].toString(),
                              //   style: TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 14,
                              //   ),
                              // ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 30,
                                color: Colors.blueAccent,
                              ),
                                onTap:(){ Navigator.of(context).push(MaterialPageRoute(builder: (context)=> pg[index]));}
                            ),

                          ),
                        ),
                      );
                    }
                ),
              ),

            ],

          ),

        ),
      ),
    );
  }



}
//pour charger charger l'image qui est dans la base de donnée
class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

}

