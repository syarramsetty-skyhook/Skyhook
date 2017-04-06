# Skyhook Precision Location for IoT

[Skyhook’s Precision Location for IoT](http://www.skyhookwireless.com/Iot) product is the location layer for IoT devices within multiple platforms. This location solution was designed for all connected devices that need to minimize bandwidth and power consumption. To support all connected devices, we’ve maintained [Precision Location](http://www.skyhookwireless.com/products/precision-location) functionality while reducing client code by 100X and data transmission by 10X, making this the lightest location solution for IoT in the market today.

To use this library you must require and instantiate Skyhook Precision Location on both the agent **and** the device.

**To add this library to your project, add** `#require "skyhook.device.nut:2.0.0"` **to the top of your device code, and** `#require "skyhook.agent.nut:2.0.0"` **to the top of your agent code.**

## Device Class Usage

### Constructor: skyhook()

The device side skyhook constructor takes no parameters.

```squirrel
#require "skyhook.device.nut:2.0.0"

skyhookDevice <- skyhook();
```

## Device Class Methods

### register()

The *register()* method opens a listener for location requests from the agent. When a request is received, the device scans the WiFi networks and sends the result back to the agent.

```squirrel
skyhookDevice.register();
```

## Agent Class Usage

**Note** The skyhook agent library code expects the device side library to be instantiated.

### Constructor: skyhook(*deviceName, skyhookKey, skyhookUrl*)

The agent side skyhook constructor takes three required parameters: the device name, your Skyhook Precision Location Key and the Skyhook Precision Location Platform URL. All parameters are strings. To get your Skyhook Precision Location Key and Location Platform URL please contact [Skyhook](http://www.skyhookwireless.com/try-skyhook-for-free).

```squirrel
#require "skyhook.agent.nut:2.0.0"

const SKYHOOK_KEY = "<YOUR_SKYHOOK_KEY_FROM_SKYHOOK_DOT_COM>";

skyhookAgent <- skyhook(SKYHOOK_KEY);
```

## Agent Class Methods

### get_location(*callback*)

The *get_location()* method takes one required parameter: a callback function. The method triggers a WiFi scan on the device then sends the results to Skyhook. Skyhook returns the device’s location and passes the results to the callback.

The callback takes two required parameters: *err* and *result*. If no errors were encountered, *err* will be null and *result* will contain a table with the keys *latitude*, *longitude* and *accuracy*. If an error occured during the request, *err* will contain the error information and *result* will be null or the raw response from Skyhook.

```squirrel
skyhookAgent.get_location(function(err, result) {
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
#require "skyhook.device.nut:2.0.0"

skyhookDevApi <- skyhook();
skyhookDevApi.register();
```

### Agent Code

```
#require "skyhook.agent.nut:2.0.0";

// Skyhook Precision Location auth key
const skyhookKey = "Skyhook-Key-From-Skyhook-Dot-Com";

// Create Skyhook Precision Location instance
skyhookAgentApi <- skyhook(skyhookKey);

function device_location(err, location) {
    if (err) {
        server.error(err);
    } else {
        server.log("Device location: " + location.longitude + ", " + location.latitude);
        server.log("Location accuracy: " + location.accuracy);
    }
}

// Wait for device to come online then get location
imp.wakeup(1.0, function() {
    server.log("Getting location");
    skyhookAgentApi.get_location(device_location);
})
```

## License

The Skyhook Precision Location for IoT library is copyright &copy; 2016, Skyhook. It is released under the [MIT licence](https://github.com/electricimp/TrueFix/blob/master/LICENSE).
