import 'package:ethiocare/languages/language.dart';

class English implements Language{
  
  @override
  String corona_virus = "corona virus";

  @override
  String app_name = "Corona contact tracker";

  //walkthrough page
  @override
  List<String> walkthrough_titles = [
    "Lets trace covid 19 together",
    "Turn your bluetooth on",
    "We alarm you when we find suspicion nearby",
    "Notify us, if you get diagnosed",
    "Till the pandemic is over, don't change any setting",
    "Disclaimer",
  ];
  @override
  List<String> walkthrough_descriptions = [
    "We are at war against this global pandemic disease that caused thousands of deaths and financial crisis. but we believe together united we can trace and win this war.",
    "The app uses your Bluetooth signal to determine when you made contact with whom. Even if you close this app, leave Bluetooth turned on.",
    "You might not have the luxury to stay home 24/7. That's why we assess your environment for possible contact with suspects. just make sure your Bluetooth is on every time.",
    "We need your help to trace and provide care. call us if you are diagnosed with COVID-19"
         " so that we can notify peoples you have contacted to self-isolate or call health center."
         "During this process, we won't share your name or any kind of your personal information under any circumstances.",
    "We will provide you up-to-date information's and updates. To get most of our services, leave the app settings as it is. Now you can start!",
    "The information  we provide are subject to the data's we collected which is highly limited "
        "so don't rely on the information's as a complete, correct indicators just take the warnings and red signs with real caution."
  ];
//
//  @override
//  List<String> walkthrough_titles = [
//    "This is covid contact tracker ",
//    "Turn your bluetooth on",
//    "We track your interaction",
//    "Till the pandemic is over, don't change any setting"
//  ];
//  @override
//  List<String> walkthrough_descriptions = [
//    "Corona virus ( scientifically known as covid-19 ) is a virus that is transmitted through body fluids manman ...... This app presents latest news , statistics and information about the virus. But above all it assesses your level of exposure to the virus.",
//    "The app uses your bluetooth history to determine when you made contact with whom. Even if you close this app, leave bluetooth turned on.",
//    "You may have not the luxury to stay home 24/7. That's why we track your interaction history to assess your risk.",
//    "We will provide you uptodate infomations and updates. To get most of our service, leave the app setting as it is. Now you can start!"
//  ];
  @override
  String walkthrough_next = "Next";
  @override
  String walkthrough_back = "Back";



  //Signup screen
  @override
  String sign_up_screen_title = "Getting Started ...";
  @override
  String sign_up_screen_description = "Make sure the information you provide is correct. You can't alter these fields later.";
  @override
  String sign_up_screen_full_name = "Full Name";
  @override
  String sign_up_phone_number = "Phone Number";
  @override
  String sign_up_next = "Start";
  @override
  String sign_up_phone_not_valid = "Required";
  @override
  String sign_up_phone_name_required ="Not valid phone number";


  //loading texts
  @override
  String loading = "Loading ... Please wait ...";
  String loading_only_once_from_internet;
  @override
  String connecting = "Connecting ...";
  @override
  String waiting_for_network = "waiting for the network";
  @override
  String not_connected = "No internet connection. Please try again later";
  @override
  String connection_error = "Couldn't connect to the network";
  String connection_error_retry = "Please turn on your device's data connection.";
  String server_error = "We couldn't process your data maybe your device is not supported... please try again later.";



  //tracker screen
  @override
  String title_waiting_for_connection = "No internet connection";
  @override
  String waiting_for_connection = "We need internet connection to evaluate your current status";
  @override
  String title_tracking = "Analyzing your status";
  @override
  String green_area = "NO GREEN AREA";
  @override 
  String green_area_description = "WE SHOULD NEVER SHOW A GREEN SIGN";
  @override
  String unknown = "Unknown";
  @override
  String title_unknown = "Unknown";
  @override
  String unknown_description = "We don't have a sufficient amount of data to analyze your status. This might indicate that you didn't turn on Bluetooth or location throughout the day or there is no contact with the exposed person detected.";
  @override 
  String warning = "Warning";
  @override
  String title_warning = "Warning";
  @override 
  String warning_description = "You should keep your social distance. Try to minimize your physical interactions with other humans.";
  @override
  String danger = "Danger";
  @override
  String title_danger = "Danger";
  @override 
  String danger_description = "You were recently nearby a person exposed to the virus. You should self isolate yourself and consult a health professional.";
  @override 
  String tracker_page_text = "Scanning your area";
  @override 
  String tracker_page_description = "Analyzing your level of exposure to the virus in 24 hours considering peoples living in your area and your recent bluetooth connections.";
  @override
  String tracker_page_error = "Waiting for a connection";
  // ???
  @override
  String tracker_page_error_description = "We need internet connection to gather more data from our server";
  @override
  String tracker_page_error_title = "Waiting for connection";

  // navigation
  @override 
  String nav_tracker = "My Status";
  @override 
  String nav_news = "News";
  @override   
  String nav_statistics = "World Situation";
  @override 
  String nav_about_corona = "About Corona";
  @override 
  String nav_help = "Help";
  @override 
  String nav_invite_friend = "Invite friends";
  @override 
  String nav_developers = "About us";
  @override 
  String nav_title = "Covid contact tracker";
  @override 
  String nav_sub_title = "by Askual-Tech teams";


  // statistics screen
  @override 
  String statistics_page_world = "World situation";
  @override 
  String statistics_page_total_cases = "Total cases";
  @override 
  String statistics_page_active_cases = "Active cases";
  @override 
  String statistics_page_serious_cases = "Serious cases";
  @override
  String statistics_page_deaths = "Deaths today";
  @override 
  String statistics_page_recovered = "Recovered";
  @override 
  String statistics_page_total_new_cases = "New cases today";
  @override 
  String statistics_page_total_deaths = "Total deaths";
  @override 
  String statistics_page_people = "People";
  @override 
  String statistics_page_sort_by = "Sort By";
  // ??
  @override 
  String statistics_page_none = "Random";
  @override 
  String statistics_page_title = "Situation";
  // ??
  @override 
  String statistics_page_total_unresolved ="" ;


  //help Screen
  String help_page_title1 = "How does covid contact tracker work?";
  String help_page_description1 = "The application tracks your location history and compares with other peoples' location history. If you were recently nearby a person infected with ( or suspected of being infected with) the virus, it will notify you to self isolate.";
  String help_page_title2 = "Can the application 100% predict my health status?";
  String help_page_description2 = "No. This application helps you to assess your level of exposure to the virus. In no way it substitutes the formal medial examination.";
  String help_page_title3 = "Should I close the app?";
  String help_page_description3 = "Sure. You can only open the application to know your status. It runs in a background.";
  String help_page_title4 = "My bluetooth is opened. Should I close it?";
  String help_page_description4 = "No. Please do not close your bluetooth since the application is based on your bluetooth connection history.";
  String help_page_title5 = "Who are you?";
  String help_page_description5 = "We are students from Astu, working to improve the lives of students' of the developing world.";


  //choose language page
  @override 
  String choose_language = "Choose Language";
  @override 
  String english = "English";
  @override 
  String amharic = "Amharic";
  @override 
  String next = "Next";



  //about corona screen
  @override
  String about_corona_title = "About Covid-19";




  //invite friends screen
@override
String invite_friends_title = "Tell your friends about this app";
@override
String invite_friends_description = "Millions of people need this app so that they can assess their exposure (to the virus of course). Please invite your beloved ones. and \n\n lets trace covid-19 together.";
@override
String invite_friends_botton_text = "Tell your Friend";


  //News
  @override 
  String news_title = "News";
  @override 
  String news_dialog_filter = "Filter by";
  @override 
  String news_dialog_ok = "Ok";


//only for debugging purpose
  String test;
  String dumtext;
  String dumtextLong;

  @override
  String statistics_page_situation;

  @override
  String needbluetoothtocontinue = "Please turn Bluetooth on to continue!!";

  @override
  String waiting_for_bluetooth_to_turn_on = "Turn bluetooth on";

  @override
  String waiting_for_bluetooth_to_turn_on_desc = "We need bluetooth connection to make the tracking process";


  @override
  String statistics_page_sort_by_name = "Name";

  @override
  var signuperrorfromserver;


  @override
  String notification_turn_on_data = "Turn your data on to get realtime analysis.";

  @override
  String notification_looking_nearby = "Looking for nearby threats.";

  @override
  String phone_number = "Phone number";

  @override
  String phone_numbers = "Phone numbers";

  @override
  String region = "Region";

  @override
  String call = "Call";

  @override
  String contributors = "Contributers";

  @override
  String developers = "Developers";

  @override
  String notSupported = "Sorry this feature requires highr android version";

  @override
  String callOneOfthisNumbersIfYouAreDiagnosed = "Use one of these numbers to inform us if you are diagnosed with COVID-19";

  @override
  String healthCenters = "Health Care Centers";

  @override
  String doyouagree = "I agree with terms of use and privacy policy.";

  @override
  String privacy_policy = "Privacy policy";

  @override
  String terms_of_use = "Terms of use";
}