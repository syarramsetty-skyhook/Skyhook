/**
 * This class is required on ElectricImp enabled device to provide
 * wifiscan results to skyhookAgentApi running in ElectricImp cloud.
 *
 * @author Satya Yarramsetty <satya.yarramsetty@trueposition.com>
 *
 * @version 2.0.0
 */
class skyhook {
  static VERSION = "2.0.0";

  static REQUEST_TAG = "skyhook.wifiscan.request";
  static RESPONSE_TAG = "skyhook.wifiscan.response";

  constructor() {}

  function register() {
    agent.on(REQUEST_TAG, function(data) {
      local wlans = imp.scanwifinetworks();
      agent.send(RESPONSE_TAG, wlans);
    }.bindenv(this));
  }
}
