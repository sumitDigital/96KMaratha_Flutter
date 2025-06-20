/*
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/logincontroller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/forgetPasswordScreen.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:text_divider/text_divider.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:facebook_app_events/facebook_app_events.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController logincontroller = Get.put(LoginController());
    return Scaffold(
   
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                SizedBox(
                  height: 60, 
                  width: 150, 
                child: Image.asset("assets/applogo.png"),  
                  ), 
                
                  const SelectLanguage()
                ]),
              ),
        
        
              const SizedBox(height: 10,),
              const SizedBox(height: 50,),
            const Text("Enter Your Email ID /Mobile Number" , style: CustomTextStyle.fieldName,),
             CustomTextField(
              textEditingController: logincontroller.emailController,
              HintText: "Please enter the registered email id / mobile number"), 
            const SizedBox(height: 20,) , 
 const Text("Enter Your Password" , 
 overflow: TextOverflow.ellipsis,
 style: CustomTextStyle.fieldName,), 
  Obx(() {
    return  CustomTextField(
      
      textEditingController: logincontroller.passwordController,
      HintText: "Please enter the valid password", 
            suffixIcon:  logincontroller.hidePassword.value == true ? IconButton(onPressed: (){
              logincontroller.alterPasswordVisiblity();
            }, icon: Icon(Icons.visibility_off, color: Colors.grey.shade500,)) : IconButton(onPressed: (){
              logincontroller.alterPasswordVisiblity();

            },
             icon: const Icon(Icons.visibility , color: Colors.blue,)), 
            obscuretext: logincontroller.hidePassword.value,
            ); 
  },), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Obx(() {
              return Row(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                  SizedBox(
                                     height: 25,
                                     width: 25,
                    child: Checkbox(
                     side: BorderSide(color: Colors.grey.shade400),
                    
                      
                                activeColor: const Color.fromARGB(255, 80, 93, 126 ,) ,
                    value: logincontroller.checkboxvalue.value, onChanged: (value) {
                    logincontroller.checkboxchange();
                                  },)
                  ) , 
                const Text("Remember Me" , style: CustomTextStyle.textbutton,) , 

             
            ],);
            },),
                GestureDetector( 
                  onTap: () {
                    //  Get.toNamed(AppRouteNames.forgetPasswordScreen);
                      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ForgetPasswordScreen(),));
                    
                  },
                  child: Text(AppLocalizations.of(context)!.forgotpassword , style: CustomTextStyle.textbutton,))
              ],), 
               const SizedBox(height: 40,), 
               
                Center(
  child: Obx(() {
    return logincontroller.isLoading.value
        ? CircularProgressIndicator() // Show loading indicator when API call is in progress
        : SizedBox(
            width: 220.41,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
              Get.toNamed(AppRouteNames.userInfoStepOne);
           
              },

              child: const Text(
                "Login with Password",
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.elevatedButton,
              ),
            ),
          );
  }),
),



                   const SizedBox(height: 10,),
        TextDivider.horizontal(text: const Text("OR" , style: CustomTextStyle.bodytext,) , ) , 
        const SizedBox(height: 10,),
          Center(child: SizedBox(
               width: 220.41, 
                    height: 50,
          child: ElevatedButton(onPressed: (){
            Get.toNamed(AppRouteNames.sendOTP);
          }, child: const Text("Login With OTP" , style: CustomTextStyle.elevatedButton))),),
     
            
      
         
     
      
        const SizedBox(height: 20,), 
     Center(
       child: Wrap(
        spacing: 10, runSpacing: 10,
        children: [
                 const Text(
                  textAlign: TextAlign.center,
                  "Don't have a profile ? " , style: CustomTextStyle.bodytext,) , 
              InkWell(
                onTap: () {
                  Get.toNamed(AppRouteNames.registerScreen);
                },
                child: const Text(
                  textAlign: TextAlign.center,
                  "Register now!", style: CustomTextStyle.textbuttonRed))
       ],),
     ),
        const SizedBox(height: 20,)
          ],)),
        ),

      ),
    );
  }
}*/
