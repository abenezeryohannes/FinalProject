

import 'package:ethiocare/shared_preference/change_subscriber.dart';

class ChangeObserver{
 
   List<ChangeSubscriber> subs = new List();

  
   void addSubs(ChangeSubscriber sub) {  removeSub(sub);  subs.add(sub);  }

  
   void onChange() {    subs.forEach((f){ if(f!=null)f.onDataChange();} );  }

   
   void removeSub(ChangeSubscriber sub){ subs.removeWhere((test){return test == sub;});}


}