

import '../Network/ApiUrls.dart';

Uri getUrl(String apiName, {var params}) {
  var uri = Uri.https(baseUrl, nestedUrl + apiName, params);
  return uri;
}