/**
 * This class can be used on ElectricImp cloud to get location of ElectricImp
 * enabled device using Skyhook Precision Location Platform.
 *
 * @author Satya Yarramsetty <satya.yarramsetty@trueposition.com>
 *
 * @version 2.0.0
 */

class skyhook {
  static VERSION = "2.0.0";

  static REQUEST_TAG = "skyhook.wifiscan.request";
  static RESPONSE_TAG = "skyhook.wifiscan.response";

  static ERROR_NO_ACCESS_POINTS = "no wifi access points";
  static ERROR_UNSUCCESSFUL_RESPONSE = "unsuccessful response from Skyhook Precision Location server";

  static SKYHOOK_LOCATION_URL = "https://api.skyhookwireless.com/wps2/location"; 

  skyhookKey = null

  /**
   * @param {string} skyhookkey
   */
  constructor(skyhookkey) {
    skyhookKey = skyhookkey;
  }

  /**
   * Get location from Skyhook Precision Location
   *
   * @param {function} callback
   *
   * @return null
   */
  function get_location(callback) {
    device.on(RESPONSE_TAG, function(wlans) {
        _get_fix(wlans, callback);
    }.bindenv(this));

    device.send(REQUEST_TAG, null);
  }

  // private function
  function _get_fix(wlans, callback) {
      if (wlans.len() < 1) {
        callback(ERROR_NO_ACCESS_POINTS, null);
        return;
      }

      local msg = "<?xml version='1.0' encoding='UTF-8'?>";
      msg = msg + "<LocationRQ xmlns='http://skyhookwireless.com/wps/2005' version='2.21' street-address-lookup='none' profiling='true'>";
      msg = msg + "<authentication version='2.2'>"
      msg = msg + format("<key key='%s' username='%s'/>", skyhookKey, imp.configparams.deviceid);
      msg = msg + "</authentication>";

      foreach (ap in wlans) {
        msg = msg + "<access-point>";
        msg = msg + format("<mac>%s</mac>" ap.bssid);
        msg = msg + format("<ssid>%s</ssid>", ap.ssid);
        msg = msg + format("<signal-strength>%d</signal-strength>", ap.rssi);
        msg = msg + "<age>0</age>";
        msg = msg + "</access-point>";
      }
      msg = msg + "</LocationRQ>";

      local headers = { "Content-Type" : "text/xml", "X-Forwarded-For" : "127.0.0.1" };
      local request = http.post(SKYHOOK_LOCATION_URL, headers, msg);
      request.sendasync(function(response) {
        if (response.statuscode == 200) {
          local fix = {latitude = null, longitude = null, accuracy = null};

          local rexp = regexp2(@"<latitude>([-+]?(\d*[.])?\d+)</latitude>");
          local results = rexp.capture(response.body);
          if (results && results.len() > 1) {
            fix.latitude = response.body.slice(results[1].begin, results[1].end);
          }

          rexp = regexp2(@"<longitude>([-+]?(\d*[.])?\d+)</longitude>");
          results = rexp.capture(response.body);
          if (results && results.len() > 1) {
            fix.longitude = response.body.slice(results[1].begin, results[1].end);
          }

          rexp = regexp2(@"<hpe>([-+]?(\d*[.])?\d+)</hpe>");
          results = rexp.capture(response.body);
          if (results && results.len() > 1) {
            fix.accuracy = response.body.slice(results[1].begin, results[1].end);
          }
          callback(null, fix);
        } else {
          callback(ERROR_UNSUCCESSFUL_RESPONSE, response);
        }
      }.bindenv(this));
  }
}
