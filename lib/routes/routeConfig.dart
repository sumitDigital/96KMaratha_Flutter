/*
class AppRouteConfig{
  static List<GetPage> route = [
    GetPage(name: AppRouteNames.loginScreen, page: () => const LoginScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.loginScreen2, page: () => const LoginScreen2() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.loginwithOTP, page: () => const LoginWithOTPScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.splashScreen, page: () =>  SplashScreen() , transition: Transition.rightToLeft ),



    GetPage(name: AppRouteNames.welcomeScreen, page: () =>  WelcomeScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.welcomeScreen2, page: () => const Welcomescreen2() , transition: Transition.rightToLeft ),


    GetPage(name: AppRouteNames.registerScreen, page: () => const RegisterScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.registerOTPScreen, page: () => const RegisterOTPScreen() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.forgetPasswordScreen, page: () => const ForgetPasswordScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.otpVerificationScreen, page: () => const VerificationScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.userInfoStepOne, page: () => const UserInfoStepOne() , transition: Transition.rightToLeft , ), 
    GetPage(name: AppRouteNames.userInfoStepTwo, page: () => const UserInfoStepTwo() , transition: Transition.rightToLeft ,  ), 
    GetPage(name: AppRouteNames.userInfoStepThree, page: () => const UserInfoStepThree() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.userInfoStepSix, page: () => const UserInfoStepSix() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.userInfoStepFour, page: () => const UserInfoStepFour() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.userInfoStepFive, page: () => const UserInfoStepFive() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.homeScreen, page: () => const Homescreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.bottomNavBar, page: () =>  BottomNavBar() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editProfile, page: () =>  const EditProfile() , transition: Transition.rightToLeft ,), 
    GetPage(name: AppRouteNames.sendOTP, page: () =>  const SendOTPScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.userDetails, page: () =>  const UserDetails(
      notificationID: 0,
      memberid: 2,) , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.myplan, page: () =>  const MyPlan() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.inVoice, page: () =>  const InVoiceScreen() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.searchScreen, page: () =>  const SearchScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.notificationScreen, page: () =>  const NotificationScreen() , transition: Transition.rightToLeft ), 
   // GetPage(name: AppRouteNames.selectCountry, page: () =>  const CountrySelectScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.selectState, page: () =>  const SelectSateScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.selectCity, page: () =>  const SelectCityScreen() , transition: Transition.rightToLeft ), 

  GetPage(name: AppRouteNames.presentselectCountry, page: () =>  const PresentCountrySelectScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.presentselectCity, page: () =>  const PresentSelectCityScreen(stateId: "2",) , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.presentselectState, page: () =>  const PresentStateScreen(countryId: "1",) , transition: Transition.rightToLeft ), 


  GetPage(name: AppRouteNames.permanentSelectCity, page: () =>  const PermanentSelectCityScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.permanentSelectCountry, page: () =>  const PermanentCountrySelectScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.permanentSelectState, page: () =>  const PermanentStateScreen() , transition: Transition.rightToLeft ), 

  GetPage(name: AppRouteNames.partnerSelectCity, page: () =>  const PartnerSelectCityScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.partnerSelectCountry, page: () =>  const PartnerCountrySelectScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.partnerSelectState, page: () =>  const PartnerStateScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.selectPlaceOfBirth, page: () =>  const PlaceOfBirthScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.advancesearchresult, page: () =>  const SearchResultScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.advancesearchByIDresult, page: () =>  const SearchByIDResultScreen() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.deleteAccount, page: () =>  const DeleteAccount() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.deactivateAccount, page: () =>  const DeactivateAccount() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.forgetPasswordOTP, page: () =>  const ForgetPasswordOTP() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.changePassword, page: () =>  const NewPasswordScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.updatePassword, page: () =>  const UpdatePasswordScreen() , transition: Transition.rightToLeft ), 

    GetPage(name: AppRouteNames.editEducationForm, page: () =>  const EditEducationForm() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editLocationForm, page: () =>  const EditLocationForm() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editLifestyleDetailsForm, page: () =>  const EditLifestyleDetails() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editAStroDetailsForm, page: () =>  const AstroDetailsScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editSpiritualDetailsForm, page: () =>  const EditSpiritualDetailsScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editPartnerExpectation, page: () =>  const EditPartnerPrefrances() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editFamilyDetails, page: () =>  const EditFamilyDetailsScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editPersonalDetailsForm, page: () =>  const EditPersonalInfoScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.editBasicInfoForm, page: () =>  const EditBasicInfoScreen() , transition: Transition.rightToLeft ),
    GetPage(name: AppRouteNames.editGalleryPhotos, page: () =>  const EditGalleryPhotosScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.changePrivacySettings, page: () =>  const EditContactPrivacy() , transition: Transition.rightToLeft ), 





    GetPage(name: AppRouteNames.editAboutMe, page: () =>  const EditAboutMeScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.updatePromptScreen, page: () =>  const UpdateAppScreen() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.addOnPLan, page: () =>  const Addonplan() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.advancedSearch, page: () =>  const AdvancedSearch() , transition: Transition.rightToLeft ), 
    GetPage(name: AppRouteNames.quickSearch, page: () =>  const BasicSearch() , transition: Transition.rightToLeft ), 















/**/


  ];
}*/
