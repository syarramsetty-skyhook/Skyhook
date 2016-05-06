TrueFixDeviceApi
================

  To add this library to your model, add the following line to the top of your device code:
  #require "TrueFixDeviceApi.class.nut:1.0.0"

  This class is required on ElectricImp enabled device to provide
  wifiscan results to TrueFixAgentApi running in ElectricImp cloud.

  Example:
  --------

    #require "TrueFix.device.nut:1.0.0"
    tfDevApi <- TrueFix();
    tfDevApi.register();

TrueFixAgentApi
===============

  To add this library to your model, add the following line to the top of your agent code:
  #require "TrueFixAgentApi.class.nut:1.0.0"

  This class can be used on ElectricImp cloud to get location of ElectricImp
  enabled device using TrueFix Location Platform.

  This class expects "TrueFixDeviceApi" loaded on ElectricImp enabled device.

  Class Methods:
  --------------

    constructor(deviceName, truefixKey, truefixUrl)
    -----------------------------------------------
      deviceName: ElectricImp enabled device name (Example: "my-eimp-dev-1")
      truefixKey: TrueFix Key (Contact TruePosition to get truefixKey)
      truefixUrl: TrueFix Location Platform Url (Contact TruePosition to get truefixUrl)
      All parameters are strings.

    get_location(callback)
    ----------------------
      callback: callback function will be called when the location is available or on error.
         function callback(fix, status) {
         }

      'fix' is a table with keys 'latitude', 'longitude' and 'accuracy'.
      'fix' may be 'null' if location is not obtained due to erros.
      'status' is a string, informational string on error cases.

  Example:
  --------

    #require "TrueFix.agent.nut:1.0.0"

    // device name
    const tfDevName = "tf-imp-1";

    // truefix auth key
    const tfKey = "TrueFix-Key-From-TruePosition-Dot-Com";

    // truefix Url
    const tfUrl = "https://trueposition.truefix.com/location";

    // create TrueFix instance
    tfAgentApi <- TrueFix(tfDevName, tfKey, tfUrl);

    function get_my_device_location(err, fix) {
      if (err) {
        server.log(err);
      } else {
        server.log("location=" + http.jsonencode(fix));
      }
    }

    // wait for device to come online then get location
    imp.wakeup(0.5, function() {
        server.log("getting location")
        tfAgentApi.get_location(get_my_device_location);
    })
