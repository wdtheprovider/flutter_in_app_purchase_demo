import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';

class ManageSubscription {
  //
  //
  //This method will check if the user has purchased the weekly subscription
  //and activate the subscription by using a sharedPreferences
  static void updateWeeklySub(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.restored ||
        purchaseDetails.status == PurchaseStatus.purchased) {
      OnePref.setPremium(true);
      OnePref.setString("subType", "Weekly");
    } else {
      resetSubscription();
    }
  }

  //
  //This method will check if the user has purchased the monthly subscription
  //and activate the subscription by using a sharedPreferences
  static void updateMonthlySub(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.restored ||
        purchaseDetails.status == PurchaseStatus.purchased) {
      OnePref.setPremium(true);
      OnePref.setString("subType", "Monthly");
    } else {
      resetSubscription();
    }
  }

  //Manage remove Ads
  static void updateRemoveAds(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.restored ||
        purchaseDetails.status == PurchaseStatus.purchased) {
      OnePref.setRemoveAds(true);
    } else {
      OnePref.setRemoveAds(false);
    }
  }

  //
  //
  //This method will reset and deactivate the subscription in the app.
  //and deactivate the subscription by using a sharedPreferences
  static void resetSubscription() {
    OnePref.setPremium(false);
    OnePref.setString("subType", "None");
  }
}
