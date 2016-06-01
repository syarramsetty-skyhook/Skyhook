/**
 * This class can be used on ElectricImp cloud to get location of ElectricImp
 * enabled device using Skyhook Precision Location Platform.
 *
 * @author Satya Yarramsetty <satya.yarramsetty@trueposition.com>
 *
 * @version 1.0.0
 */

class SPL {
  static version = [1, 0, 0];

  static REQUEST_TAG = "spl.wifiscan.request";
  static RESPONSE_TAG = "spl.wifiscan.response";

  static ERROR_NO_ACCESS_POINTS = "no wifi access points";
  static ERROR_UNSUCCESSFUL_RESPONSE = "unsuccessful response from Skyhook Precision Location server";

  deviceName = null;
  splKey = null
  splUrl = null;

  /**
   * @param {string} devicename
   * @param {string} splkey
   * @param {string} splurl
   */
  constructor(devicename, splkey, splurl) {
    deviceName = devicename;
    splKey = splkey;
    splUrl = splurl;
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
      }

      local msg = "<?xml version='1.0' encoding='UTF-8'?>";
      msg = msg + "<LocationRQ xmlns='http://skyhookwireless.com/wps/2005' version='2.21' street-address-lookup='none' profiling='true'>";
      msg = msg + "<authentication version='2.2'>"
      msg = msg + format("<key key='%s' username='%s'/>", splKey, deviceName);
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

      local headers = { "Content-Type" : "text/xml" };
      local request = http.post(splUrl, headers, msg);
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
