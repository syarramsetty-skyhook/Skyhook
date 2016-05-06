/**
 * This class is required on ElectricImp enabled device to provide
 * wifiscan results to TrueFixAgentApi running in ElectricImp cloud.
 *
 * @author Satya Yarramsetty <satya.yarramsetty@trueposition.com>
 *
 * @version 1.0.0
 */
class TrueFix {
  static version = [1, 0, 0];

  static REQUEST_TAG = "truefix.wifiscan.request";
  static RESPONSE_TAG = "truefix.wifiscan.response";

  constructor() {}

  function register() {
    agent.on(REQUEST_TAG, function(data) {
      local wlans = imp.scanwifinetworks();
      agent.send(RESPONSE_TAG, wlans);
    }.bindenv(this));
  }
}