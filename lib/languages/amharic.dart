import 'package:ethiocare/languages/language.dart';


class Amharic implements Language{
  
  @override
  String corona_virus = "ኮሮና ቫይረስ";

  @override
  String app_name = "ኢትዮ ኬር";

  //walkthrough page
  @override
  List<String> walkthrough_titles = [
    "ኮቪድ 19ን አብረን እንከላከል",
    "የብሉቱዝዎን ያብሩ",
    "በአቅራቢያዎ አጠራጣሪ ጉዳይ ስናይ እናነቃዎታለን",
    "ኮሮና ከተገኘብዎት ወዲያውኑ ያሳውቁን",
    "ወረርሺኙ እስኪያበቃ የስልክዎን setting አይለውጡ",
    "ማሳሰቢያ",
  ];

  @override
  List<String> walkthrough_descriptions = [
    "የጤንነት እና የኢኮኖሚ ባለጋራ ከሆነው ከዚህ አለምአቀፍ ወረርሽኝ ጋር ጦርነት ላይ ነን። ከተባበርን ግን እናሸንፈዋለን።",
    "ይህ መተግበሪያ የብሉቱዝዎ ሞገድን በመጠቀም ከማን ጋር እንደተገናኙ ይመዘግባል። መተግበሪያውን ቢዘጉትም ብሉቱዝዎን ክፍት መተው አይርሱ።",
    "ቤትዎት ውስጥ ሁልግዜ መቀመጥ ላይችሉ ይችላሉ። ለዛም ነው የተገኛኙዋቸውን ሰዎች በመመልከት የተጋላጭነትዎን መጠን የምናሰላው። ብሉቱዝዎ ክፍት መሆኑን ብቻ አይርሱ።",
    "በምናደርገው ጥረት የርሶን እገዛ እንሻለን። በcovid-19 ከተያዙ ለኛ ማሳወቅዎን አይዘንጉ።"
         " ከዚያም ከርሶ ጋር የቅርብ ንክኪ ለነበራቸው ሰዎች የማስጠንቀቂያ መልእክት እንልካለን።"
         "ይህንን ስናደርግ ስሞትንም ሆነ ሌሎች ግላዊ መረጃዎትን ለሶስተኛ ወገን አሳልፈን አንሰጥም።",
    "በተጨማሪም አዳዲስ መረጃዎችን እናሳውቅዎታለን። የመተግበሪያውን setting እንዳለ ይተዉት።",
    "የምናቀርበው መረጃ በሰበሰብነው ውስን ዳታ ላይ የተመሰረተ ነው።"
        "በመሆኑም በመተግበሪያችን የሚያገኙትን መረጃ ሙሉ አለመሆን ይገንዘቡ። ለቀይ ምልክቶችንና ማስጠንቀቂያዎች ግን አጽንኦት ይስጡ።"
  ];

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
  String walkthrough_next = "ቀጣይ";
  @override
  String walkthrough_back = "ወደኋላ";




  //Signup screen
  @override
  String sign_up_screen_title = "በመጀመር ላይ ...";
  @override
  String sign_up_screen_description = "ያስገቡት መረጃ ትክክለኛ መሆኑን ያረጋግጡ። እኚን መረጃዎች በኋላ መለወጥ አይችሉም።";
  @override
  String sign_up_screen_full_name = "ሙሉ ስም";
  @override
  String sign_up_phone_number = "ስልክ ቁጥር";
  @override
  String sign_up_next = "ጀምር";
  @override
  String sign_up_phone_not_valid = "ማስገባት አለብዎት";
  @override
  String sign_up_phone_name_required ="ትክክለኛ ስልክ ቁጥር አይደለም";


  //loading texts
  @override
  String loading = "በመጫን ላይ ... ትንሽ ይጠብቁን";
  String loading_only_once_from_internet;
  @override
  String connecting = "በመገናኘት ላይ ...";
  @override
  String waiting_for_network = "ኔትወርኩን በመጠበቅ ላይ";
  @override
  String not_connected = "ከኔትወርክ ጋር መገናኘት አልቻለም";
  @override
  String connection_error = "ከኔትወርክ ጋር መገናኘት አልቻለም";
  String connection_error_retry = "እባክዎን የስልኮን የኢንተርኔት ግንኙነት ይክፈቱ";
  String server_error = "መረጃዎን ማግኘት አልተቻለም። እባክዎን ትንሽ ቆይተው እንደገና ይሞክሩ";


  //tracker screen
  @override
  String title_waiting_for_connection = "ኢንተርኔት ግንኙንት የለም";
  @override
  String waiting_for_connection = "ያሉበትን ሁኔታ ለማወቅ ኢንተርኔት ግንኙነት እንፈልጋለን";
  @override
  String title_tracking = "ሁኔታዎትን በመገምገም ላይ ...";
  @override
  String green_area = "NO GREEN AREA";
  @override 
  String green_area_description = "WE SHOULD NEVER SHOW A GREEN SIGN";
  @override
  String unknown = "አልታወቀም";
  @override
  String title_unknown = "አልታወቀም";
  @override
  String unknown_description = "ያሉበትን ሁኔታ ለመናገር የሚያስችል በቂ መረጅ አልሰበሰብንም። ለቀጣይ ጊዜ ብሉቱዝዎ ቀኑን ሙሉ ክፍት ሆኖ መቀየቱን ያረጋግጡ ።";
  @override 
  String warning = "ማሳሰቢያ";
  @override
  String title_warning = "ማሳሰቢያ";
  @override 
  String warning_description = "ማህበራዊ ርቀትዎን መጠበቅ አለብዎት። ከሌሎች ሰዎች ጋር ያለዎትን ግንኙነቶች ለመቀነስ ይሞክሩ ፡፡";
  @override
  String danger = "አደጋ";
  @override
  String title_danger = "አደጋ";
  @override 
  String danger_description = "በቅርቡ ለኮሮና ቫይረስ ተጋላጭ ከሆነ ሰው ጋር ተገናኝተው ነበር። ራስዎትን አግለው ያስቀምጡ ወይም በአቅራቦያዎት የሚገኝ የጤና ድርጅትን ያግኙ።";
  @override 
  String tracker_page_text = "አከባቢዎን በመቃኘት ላይ";
  @override 
  String tracker_page_description = "በአከባቢዎ የሚኖሩ ሰዎችን እና የቅርብ ጊዜ የብሉቱዝ ግንኙነቶችዎን ከግምት ውስጥ በማስገባት በ 24 ሰዓታት ውስጥ ለቫይረሱ የተጋለጡበትን ደረጃ በመተንተን ላይ...";
  @override
  String tracker_page_error = "የኢንተርኔት ግንኙነትን በመጠበቅ ላይ";
  // ???
  @override
  String tracker_page_error_description = "ተጨማሪ መረጃ ለመሰብሰብ የኢንተርኔት ግንኙነትን እንሻለን";
  @override
  String tracker_page_error_title = "የኢንተርኔት ግንኙነትን በመጠበቅ ላይ";

  // navigation
  @override 
  String nav_tracker = "የኔ ሁኔታ";
  @override 
  String nav_news = "ዜና";
  @override   
  String nav_statistics = "የአለም ሁኔታ";
  @override 
  String nav_about_corona = "ስለ ኮሮና";
  @override 
  String nav_help = "እርዱኝ";
  @override 
  String nav_invite_friend = "ጓደኛን ለመጋበዝ";
  @override 
  String nav_developers = "ስለ እኛ";
  @override 
  String nav_title = "የኮሮና ግንኙነት አሳሽ";
  @override 
  String nav_sub_title = "by Askual-Tech teams";


  // statistics screen
  @override 
  String statistics_page_world = "የአለም ሁኔታ";
  @override 
  String statistics_page_total_cases = "አጠቃላይ ኬዞች";
  @override 
  String statistics_page_active_cases = "አሁናዊ ኬዞች";
  @override 
  String statistics_page_serious_cases = "ከባድ ኬዞች";
  @override
  String statistics_page_deaths = "የዛሬ ሞት";// መጠን";
  @override 
  String statistics_page_recovered = "ያገገሙ";
  @override 
  String statistics_page_total_new_cases = "የዛሬ ኬዞች";//አዲስ
  @override 
  String statistics_page_total_deaths = "አጠቃላይ ሞት";// መጠን";
  @override 
  String statistics_page_people = "ሰዎች";
  @override 
  String statistics_page_sort_by = "በዚህ ሰድር";
  // ??
  @override 
  String statistics_page_none = "የዘፈቀደ";
  @override 
  String statistics_page_title = "ሁኔታ";
  // ??
  @override 
  String statistics_page_total_unresolved ="" ;


  //help Screen
  String help_page_title1 = "እንዴት ነው የሚሰራው";
  String help_page_description1 = "ትግበራ የአካባቢዎን ታሪክ የሚከታተል እና ከሌሎች ሰዎች የአካባቢ ታሪክ ጋር ያነፃፅራል። በቅርቡ በቫይረሱ ​​በቫይረሱ ​​የተያዙ (ወይም በቫይረሱ ​​ተይዘው የነበረ) ሰው በአጠገብዎ ከነበሩ እራስዎን ማግለል ያሳውቅዎታል።";
  String help_page_title2 = "መተግበሪያው 100% የጤና ሁኔታዬን ሊተነብይ ይችላል?";
  String help_page_description2 = "ይህ መተግበሪያ ለቫይረሱ የተጋለጡበትን ደረጃ ለመገምገም ይረዳዎታል ፡፡ መደበኛ የሕክምና ምርመራን በምንም መንገድ አይተካው ፡፡";
  String help_page_title3 = "መተግበሪያውን መዝጋት አለብኝ?";
  String help_page_description3 = "እርግጠኛ ፡፡ ሁኔታዎን ለማወቅ ብቻ ማመልከቻውን መክፈት ይችላሉ። እሱ በጀርባ ይሠራል።";
  String help_page_title4 = "ብሉቱዝ ተከፍቷል። መዝጋት አለብኝ?";
  String help_page_description4 = "አይ። ትግበራው በብሉቱዝ ግንኙነትዎ ታሪክ ላይ የተመሠረተ ስለሆነ ብሉቱዝዎን አይዝጉ።";
  String help_page_title5 = "ማነ ናቹ?";
  String help_page_description5 = "እኛ በማደግ ላይ ያለችውን ዓለም የተማሪዎችን ሕይወት ለማሻሻል የምንሰራው የአስቱ ተማሪዎች ነን።";


  //choose language page
  @override 
  String choose_language = "ቋንቋ ይምረጡ";
  @override 
  String english = "English";
  @override 
  String amharic = "አማርኛ";
  @override 
  String next = "ቀጣይ";



  //about corona screen
  @override
  String about_corona_title = "ስለ ኮቪድ 19";


    //invite friends screen
    @override
    String invite_friends_title = "ለጓደኛዎ ስለዚህ መተግበሪያ ይንገሩ።";
    @override
    String invite_friends_description = "ለሚሊዮኖች ይህ መተግበሪያ ያስፈልጋል። እባክዎትን ለወዳጅ ዘመድዎ ያጋሩ።";
    @override
    String invite_friends_botton_text = "ለጓደኛዎ ይንገሩ";





  //News
  @override 
  String news_title = "ዜና";
  @override 
  String news_dialog_filter = "በዚህ ለይ";
  @override 
  String news_dialog_ok = "እሺ";


//only for debugging purpose
  String test;
  String dumtext;
  String dumtextLong;

  @override
  String statistics_page_situation;

  @override
  String needbluetoothtocontinue = "ለመቀጠል ብሉቱዝዎን ያብሩ!!";

  @override
  String waiting_for_bluetooth_to_turn_on = "ብሉቱዝዎ";

  @override
  String waiting_for_bluetooth_to_turn_on_desc = "የብሉቱዝዎ ሞገዱ መብራት አለበት።";


  @override
  String statistics_page_sort_by_name = "ስም";
  

  @override
  var signuperrorfromserver;

  @override
  String notification_turn_on_data = "አሁናዊ መረጃዎችን ለማግኘት የስልክዎን የኢንተርኔት ኮኔክሽን ያብሩ።";

  @override
  String notification_looking_nearby = "በቅርቦ ያሉ ስጋቶችን በመፈለግ ላይ።";

  @override
  String phone_number = "ስልክ ቁጥር";

  @override
  String phone_numbers = "ስልክ ቁጥሮች";

  @override
  String region = "ክልል";

  @override
  String call = "ይደውሉ";

  @override
  String contributors = "ተባባሪዎች";

  @override
  String developers = "የሶፍትዌሩ አበልጻጊዎች";

  @override
  String notSupported = "ይቅርታ ይህን ለመጠቀም የስልክዎት ደረጃ ከፍ ማለት አደለም።";

  @override
  String callOneOfthisNumbersIfYouAreDiagnosed = "በኮቪድ 19 መያዝዎን ለኛ ለማስታወቅ እኚህን ስልክ ቁጥሮች ይጠቀሙ።";

  @override
  String healthCenters = "የጤና ማእከላት";



  @override
  String doyouagree = "ከግላዊነት ፖሊሲ እና ከአጠቃቀም መመሪያው ጋር እስማማለሁ";
  @override
  String privacy_policy = "ግላዊነት ፖሊሲ";
  @override
  String terms_of_use = "የአጠቃቀም መመሪያ";


  
}