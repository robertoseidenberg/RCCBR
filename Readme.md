## RCCBR (Bathroom remote)

Concept app for remotely controlling devices in your bathroom.


###Overview

---

What the app can do:

* Select device from list of available installations in your bathroom
* Display viewcontroller for selected device (currently only bathtub)
* Simulate watertap handles
* Simulate water in bathtub
* Simulate current water temperature


### Setup

---

* Build and run
* Install the app on a device for additional eye cand (swashing water dependent on device orientation)


### Dependencys

---

**Running the app:**

* The app relies on a running server (Apps/Server in sources) returning a JSON string. See kRCCRemoteBathtubControllerURL in RCCBathtubViewController.m (Apps/Client in sources)


**Localization**

* Localization files are beeing generated using [SBGXLSToLocalizableStrings](https://github.com/robertoseidenberg/SBGXLSToLocalizableStrings)

**UI Resources**

* All gfx resources are stored in UI.psd. Layer naming is optimized for image export using [Slicy](http://macrabbit.com/slicy/)



### Documentation

---

Documentation is beeing generated using [appledoc](https://github.com/tomaz/appledoc) by building the Documentation target. The generated docs will be stored in the XCode docs path and can be read in the organizer.


### Known issues

---

**UI:**

* Layout optimized for iPhone5 screen. On smaller screens the top part of the screen is beeing cropped. The app is still functional but does not look exactly pretty.

**MBAlertView:**

* XCode Analyzer: MBSpinningCircle: Multiple warnings: **No further investigation done**
* XCode Analyzer: DPMeterView: Multiple warnings: **No further investigation done**
* Deploymate: MBAlertView.m (483): Deplrecated method (iOS6.0) -(void)viewDidUnload: **No further investigation done**


### Todo:

---

Implementation as of now is in a somewhat incomplete state. This app acts as a client side simulation of a potential state of a remote bathtub. The server does not provide any state apart from the inital values. The model classes are engineered in a way so that they are easily extensible with functionality that incorporates server data arriving at irregular time intervals. See comments in code on how this would be hooked in.


### Architecture

---

Model and UI implementations are stateless. This makes sense for the following reasons:

* Synchronizing the simulation with remote server data for a real bathtub that will return divergent values that need to be matched
* UIs relying on states exponentially boost complexity with every state introduced

This specific case exposes the follwing states: 

* Two knobs with 101 states each
* Updating water (eg. 4x per second = 240states per minute)
* Updating temperature values (eg. 4x per second = 240states per minute)
* Server data from real bathtub arriving at irregualr time intervals (eg. 2x per minute)

Assumed the app is running for 5 minutes, that sums up to 490 states. If you only turn one knob one time. Playing around to get the water temperature right boosts the sum of states.



### Acknowledgements

---

RCCBR makes heave use these open source projects::

Model classes:

* [UIColor+CrossFade](https://github.com/cbpowell/UIColor-CrossFade)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [NSObject+BlockObservation](https://gist.github.com/andymatuschak/153676)
* [MGTwitterEngine](https://github.com/mattgemmell/MGTwitterEngine/) (NSString+UUID)
* [NSTimer-Blocks](https://github.com/jivadevoe/NSTimer-Blocks)

View classes:

* [MBAlertView](https://github.com/mobitar/MBAlertView)
* [MeterView](https://github.com/frankus/MeterView)
* [DPMeterView](https://github.com/dulaccc/DPMeterView)
* [MHRotaryKnob](https://github.com/hollance/MHRotaryKnob)


### License

---

RCCBR is licensed under the MIT License.