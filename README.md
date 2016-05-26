# TrueFix

The TrueFix library allows you to easily integrate [Skyhook’s TrueFix® Precision Location ](http://www.skyhookwireless.com/products/precision-location) platform, which enables secure, private location services.

To use this library you must require and instantiate TrueFix on both the agent **and** the device.

**To add this library to your project, add** `#require "TrueFix.device.nut:1.0.0"` **to the top of your device code, and** `#require "TrueFix.agent.nut:1.0.0"` **to the top of your agent code.**

## Device Class Usage

### Constructor: TrueFix()

The device side TrueFix constructor takes no parameters.

```squirrel
#require "TrueFix.device.nut:1.0.0"

trueFixDevice <- TrueFix();
```

## Device Class Methods

### register()

The *register()* method opens a listener for location requests from the agent. When a request is received, the device scans the WiFi networks and sends the result back to the agent.

```squirrel
trueFixDevice.register();
```

## Agent Class Usage

**Note** The TrueFix agent library code expects the device side library to be instantiated.

### Constructor: TrueFix(*deviceName, truefixKey, truefixUrl*)

The agent side TrueFix constructor takes three required parameters: the device name, your TrueFix Key and the TrueFix Location Platform URL. All parameters are strings. To get your TrueFix Key and Location Platform URL please contact [Skyhook](http://www.skyhookwireless.com/try-skyhook-for-free).

```squirrel
#require "TrueFix.agent.nut:1.0.0"

const DEV_NAME = "tf-imp-1";
const TRUEFIX_KEY = "<YOUR_TRUEFIX_KEY_FROM_SKYHOOK_DOT_COM>";
const TRUEFIX_URL = "https://trueposition.truefix.com/location";

trueFixAgent <- TrueFix(DEV_NAME, TRUEFIX_KEY, TRUEFIX_URL);
```

## Agent Class Methods

### get_location(*callback*)

The *get_location()* method takes one required parameter: a callback function. The method triggers a WiFi scan on the device then sends the results to TrueFix. TrueFix returns the device’s location and passes the results to the callback.

The callback takes two required parameters: *err* and *result*. If no errors were encountered, *err* will be null and *result* will contain a table with the keys *latitude*, *longitude* and *accuracy*. If an error occured during the request, *err* will contain the error information and *result* will be null or the raw response from TrueFix.

```squirrel
trueFixAgent.get_location(function(err, result) {
    if (err) {
        server.error(err);
    } else {
        server.log("Device location: " + result.longitude + ", " + result.latitude);
        server.log("Location accuracy: " + result.accuracy);
    }
});
```

## Full Example

### Device Code

```
#require "TrueFix.device.nut:1.0.0";

tfDevApi <- TrueFix();
tfDevApi.register();
```

### Agent Code

```
#require "TrueFix.agent.nut:1.0.0";

// Device name
const tfDevName = "tf-imp-1";

// Truefix auth key
const tfKey = "TrueFix-Key-From-Skyhook-Dot-Com";

// Truefix URL
const tfUrl = "https://trueposition.truefix.com/location";

// Create TrueFix instance
tfAgentApi <- TrueFix(tfDevName, tfKey, tfUrl);

function getMyDeviceLocation(err, fix) {
    if (err) {
        server.error(err);
    } else {
        server.log("Device location: " + fix.longitude + ", " + fix.latitude);
        server.log("Location accuracy: " + fix.accuracy);    
    }
}

// Wait for device to come online then get location
imp.wakeup(1.0, function() {
    server.log("Detting location");
    tfAgentApi.get_location(getMyDeviceLocation);
})
```

## License

The Truefix library is copyright &copy; 2016, Skyhook. It is released under the [MIT licence](https://github.com/electricimp/TrueFix/blob/master/LICENSE).
