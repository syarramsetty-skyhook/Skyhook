# TrueFix

The TrueFix libray allows you to easily integrate with [Skyhook's TrueFix®](http://www.trueposition.com/products/truefix-platform) platform, which enables secure, privaten location services.

To use this library you must require and instantiate TrueFix in both the agent and device code.

**To add this library to your project, add `#require "TrueFix.device.nut:1.0.0"` to the top of your device code, and add `#require "TrueFix.agent.nut:1.0.0"` to the top of your agent code.**

-----------------------------------------------

## Device Class Usage

### Constructor: TrueFix()

The device side TrueFix constructor takes no parameters.

```squirrel
trueFixDevice <- TrueFix();
```

## Device Class Methods

### register()

The *register* method opens a listener for location requests from the agent.  When a request is received the device scans the wifi networks and sends the result back to the agent.

```squirrel
trueFixDevice.register();
```

-----------------------------------------------

## Agent Class Usage

The *TrueFix* agent side library expects the device side *TrueFix* library to be initialized.

### Constructor: TrueFix(*deviceName, truefixKey, truefixUrl*)

The agent side TrueFix constructor takes three required parameters: the deviceName, TrueFix Key, and TrueFix Location Platform Url.  All parameters are strings.  To get the TrueFix Key and Location Platform Url please contact TruePosition.

```squirrel
const devName = "tf-imp-1";
const trueFixKey = "TrueFix-Key-From-TruePosition-Dot-Com";
const trueFixUrl = "https://trueposition.truefix.com/location";

trueFixAgent <- TrueFix(devName, trueFixKey, trueFixUrl);
```

## Agent Class Methods

### get_location(callback)

The *get_location* method takes one required parameter: a callback function.  The method runs a wifi scan on the device, then sends the results to TrueFix.  TrueFix then returns the location and passes the results to the callback.

The callback takes two required parameters: err, and result.  If no errors were encountered, err will be null and the result will contain a table with keys *latitude*, *longitude* and *accuracy*. If an error occured during the request, err will contain the error information and result will be null or the raw response from TrueFix.

```squirrel
trueFixAgent.get_location(function(err, res) {
      if (err) {
        server.log(err);
      } else {
        server.log("location=" + http.jsonencode(res));
      }
});
```

--------

##Full Example:

###Device Code:

```squirrel
#require "TrueFix.device.nut:1.0.0";

tfDevApi <- TrueFix();
tfDevApi.register();
```

###Agent Code:

```squirrel
#require "TrueFix.agent.nut:1.0.0";

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
```
