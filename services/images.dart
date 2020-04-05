import 'package:flutter/widgets.dart';

String getDefaultAccommodationImageURL() {
  return "https://www.businesstravelnewseurope.com/uploadedImages/1_Sections/Lodging/Generic%20hotel%20room.jpg";
}

String getDefaultActivityImageURL() {
  return "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Buckingham_Palace_UK.jpg/2560px-Buckingham_Palace_UK.jpg";
}

void preloadImages(BuildContext context, Map accommodation, Map itinerary) {
  var configuration = createLocalImageConfiguration(context);
  List<String> urls = [];

  String defaultAccommodationURL = getDefaultAccommodationImageURL();
  urls.add(defaultAccommodationURL);

  String defaultActivityURL = getDefaultActivityImageURL();
  urls.add(defaultActivityURL);

  String accommodationImageURL = accommodation["image_url"];
  if (accommodationImageURL != null) {
    urls.add(accommodationImageURL);
  }

  for (List day in itinerary.values) {
    for (Map activity in day) {
      String activityURL = activity["bestPhoto"];
      if (activityURL != null) {
        urls.add(activityURL);
      }
    }
  }

  for (String url in urls) {
    NetworkImage(url)..resolve(configuration);
  }
}
