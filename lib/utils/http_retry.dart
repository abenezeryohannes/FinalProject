import 'dart:io';

import 'package:ethiocare/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';


class HttpRetry{
    
    static bool debugMode = true;
    static final String baseUrl = Constants.releaseBaseUrl;
    // static final String baseUrl = "http://192.168.137.1/ShimmerWeb/public/api/";
    static final int totalretry = 5;
    static final int timeOut = 5;
    int retry = 0;

    HttpRetry() { 
      
      retry  = 0;}

     Future<http.Response> get(String path) async{
          http.Response response;
          retry = 0;
          for(;retry<=totalretry;){
                    if(retry>1) {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none&& !debugMode) { 
                          sleep(const Duration(seconds: 5));
                          continue;
                      }
                    }
                    response = await http.get(path).then((onValue){
                                            return onValue;
                                      }).catchError((onError){
                                          if(retry<=totalretry) return;
                                          print(path + " error: "+onError+"\n retrying ("+retry.toString()+" out of "+totalretry.toString()+")... ");
                                      }).timeout(new Duration(seconds: timeOut), onTimeout: (){
                                          if(retry<=totalretry)
                                          print(path + " timeout \n retrying ("+retry.toString()+" out of "+totalretry.toString()+")... ");
                                          return null;
                                      });
                        retry++;
                        if(response == null) {continue;}
                        if( response.statusCode == 200) break;   
                    }
          return response;
    }

     Future<http.Response> post(String path, {Map<String, String> body, headers}) async{
         http.Response response;
         retry = 0;
        for(;retry<=totalretry;){
          if(retry>1) {
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none && !debugMode) {
                sleep(const Duration(seconds: 5));
                continue;
            }
          }
          response = await http.post( path, body:body, headers:headers).then((onValue){
                                  return onValue;
                            }).catchError((onError){
                                if(retry<=totalretry) return;
                                print(path + " body: "+body.toString()+ " error: "+onError+"\n retrying ("+retry.toString()+" out of "+totalretry.toString()+")... ");
                            }).timeout(new Duration(seconds: timeOut), onTimeout: (){
                                if(retry<=totalretry)
                                print(path + " body: "+body.toString()+ " timeout \n retrying ("+retry.toString()+" out of "+totalretry.toString()+")... ");
                                return null;
                            });
              retry++;
              if(response == null) {continue;}
              if( response.statusCode == 200) break;   
          }
          return response;
    }

}