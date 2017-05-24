# Skyhook Precision Location for IoT

[Skyhook’s Precision Location for IoT](http://www.skyhookwireless.com/products/precision-location) product is secure, flexible and scaleable, and provides location information for asset intelligence and/or real-time mapping. It was designed for all connected devices that need to minimize bandwidth and power consumption. 

To use this library you must require and instantiate Skyhook Precision Location on both the agent **and** the device.

**To add this library to your project, add** `#require "skyhook.device.nut:2.0.1"` **to the top of your device code, and** `#require "skyhook.agent.nut:2.0.1"` **to the top of your agent code.**

## Device Class Usage

### Constructor: Skyhook()

The device-side Skyhook constructor takes no parameters.

```squirrel
#require "skyhook.device.nut:2.0.1"

skyhookDevice <- Skyhook();
```

## Device Class Methods

### register()

The *register()* method opens a listener for location requests from the agent. When a request is received, the device scans the WiFi networks and sends the result back to the agent.

```squirrel
skyhookDevice.register();
```

## Agent Class Usage

**Note** The Skyhook agent library code expects the device side library to be instantiated, so we recommend your device code signals its readiness to the agent before the library is instantiated on the agent.

### Constructor: Skyhook(*skyhookKey*)

The agent-side Skyhook constructor takes one, required parameter: your Skyhook Precision Location Key as a string. To get your Skyhook Precision Location Key, please contact [Skyhook](http://www.skyhookwireless.com/try-skyhook-for-free).

```squirrel
#require "skyhook.agent.nut:2.0.1"

const SKYHOOK_KEY = "<YOUR_SKYHOOK_KEY_FROM_SKYHOOK_DOT_COM>";

skyhookAgent <- Skyhook(configSKYHOOK_KEY);
```

## Agent Class Methods

### getLocation(*callback*)

The *getLocation()* method takes one required parameter: a callback function. The method triggers a WiFi scan on the device then sends the results to Skyhook. Skyhook returns the device’s location and passes the results to the callback.

The callback takes two required parameters: *err* and *result*. If no errors were encountered, *err* will be null and *result* will contain a table with the keys *latitude*, *longitude* and *accuracy*. If an error occurred during the request, *err* will contain the error information and *result* will be `null` or the raw response from Skyhook.

```squirrel
skyhookAgent.getLocation(function(err, result) {
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
#require "skyhook.device.nut:2.0.1"

skyhookDev <- Skyhook();
skyhookDev.register();

agent.send("ready", true);
```

### Agent Code

```
#require "skyhook.agent.nut:2.0.1";

// Skyhook Precision Location auth key
const skyhookKey = "Skyhook-Key-From-Skyhook-Dot-Com";

// Create Skyhook Precision Location instance
skyhookAgent <- Skyhook(skyhookKey);

function deviceLocation(err, location) {
    if (err) {
        server.error(err);
    } else {
        server.log("Device location: " + location.longitude + ", " + location.latitude);
        server.log("Location accuracy: " + location.accuracy);
    }
}

// Wait for device to come online then get location
device.on("ready", function(dummyValue) {
    server.log("Getting device location...");
    skyhookAgent.getLocation(deviceLocation);
});
```

## License

The Skyhook Precision Location for IoT library is copyright &copy; 2016-17, Skyhook. It is released under the [MIT licence](https://github.com/electricimp/Skyhook/blob/master/LICENSE).
