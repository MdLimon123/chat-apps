

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{

var imageFile ="".obs;
  TextEditingController fullNameController = TextEditingController();

  
// profile image add

  void selectedImage(ImageSource source) async{
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if(pickedFile != null){
      cropImage(pickedFile);
    }

  }

  // profile image cropped

  void cropImage(XFile file) async{
   CroppedFile? croppedImage =  await ImageCropper().cropImage(sourcePath:
   file.path,
     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
     compressQuality: 15
   );

   if(croppedImage !=null){
     imageFile.value = croppedImage.path;

   }

  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
  }



  // pick image
  void showPhotoOption(BuildContext context){

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Upload Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectedImage(ImageSource.gallery);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text('Select Gallery'),
            ),
            
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectedImage(ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
            )
          ],
        ),
      );
    });
    
  }




}