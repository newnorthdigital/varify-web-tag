___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Varify A/B Testing",
  "categories": ["EXPERIMENTATION"],
  "brand": {
    "id": "brand_varify",
    "displayName": "New North Digital",
    "thumbnail": ""
  },
  "description": "Varify A/B testing snippet. Load the Varify script, configure consent-aware tracking activation, and enable experiment data in the dataLayer.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "instanceId",
    "displayName": "Instance ID",
    "simpleValueType": true,
    "help": "Your Varify instance ID (found in your Varify dashboard under Settings).",
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "consentMode",
    "checkboxText": "Enable consent-aware tracking",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "When enabled, Varify will not push events to the dataLayer until varify.setTracking(true) is called. Use this with consent management platforms."
  },
  {
    "type": "GROUP",
    "name": "debugging",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "debug",
        "checkboxText": "Log debug messages to console",
        "simpleValueType": true
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
var injectScript = require('injectScript');
var copyFromWindow = require('copyFromWindow');
var setInWindow = require('setInWindow');
var callInWindow = require('callInWindow');
var makeString = require('makeString');
var makeInteger = require('makeInteger');

var enableDebug = data.debug;
var debugLog = function(msg) {
  if (enableDebug) log('Varify GTM - ' + msg);
};

var instanceId = makeInteger(data.instanceId);

debugLog('Initialising with instance ID: ' + instanceId);

// Set up the varify global object
var varifyObj = copyFromWindow('varify') || {};
varifyObj.iid = instanceId;
setInWindow('varify', varifyObj, true);

debugLog('Set window.varify.iid = ' + instanceId);

// If consent mode is enabled, Varify won't push dataLayer events until activated
// The user should call varify.setTracking(true) after consent is granted
// This can be done via GTM tag sequencing with a Custom HTML tag

// Inject the Varify script
var scriptUrl = 'https://app.varify.io/varify.js';

injectScript(scriptUrl, function() {
  debugLog('Varify script loaded successfully');

  // If consent mode is NOT enabled, activate tracking immediately
  if (!data.consentMode) {
    // Check if setTracking exists and call it
    var varifyLoaded = copyFromWindow('varify');
    if (varifyLoaded && varifyLoaded.setTracking) {
      callInWindow('varify.setTracking', true);
      debugLog('Tracking activated immediately (no consent mode)');
    }
  } else {
    debugLog('Consent mode enabled - waiting for varify.setTracking(true) call');
  }

  data.gtmOnSuccess();
}, function() {
  debugLog('Varify script failed to load');
  data.gtmOnFailure();
}, 'varify-script');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://app.varify.io/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiId": "2"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "varify"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "varify.setTracking"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "varify.iid"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiId": "3"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Basic init - script loads and varify.iid is set
  code: |-
    const mockData = {
      instanceId: '12345',
      consentMode: false,
      debug: false
    };

    mock('copyFromWindow', function(key) {
      if (key === 'varify') return undefined;
      return undefined;
    });

    let setInWindowCalls = [];
    mock('setInWindow', function(key, value, overwrite) {
      setInWindowCalls.push({key: key, value: value});
    });

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      assertThat(url).isEqualTo('https://app.varify.io/varify.js');
      onSuccess();
    });

    runCode(mockData);

    assertThat(setInWindowCalls.length).isGreaterThan(0);
    assertThat(setInWindowCalls[0].key).isEqualTo('varify');
    assertThat(setInWindowCalls[0].value.iid).isEqualTo(12345);
    assertApi('gtmOnSuccess').wasCalled();

- name: Consent mode disabled - setTracking called
  code: |-
    const mockData = {
      instanceId: '12345',
      consentMode: false,
      debug: true
    };

    mock('copyFromWindow', function(key) {
      if (key === 'varify') return { setTracking: function() {} };
      return undefined;
    });

    mock('setInWindow', function() {});

    let callInWindowArgs = [];
    mock('callInWindow', function(fn, arg) {
      callInWindowArgs.push({fn: fn, arg: arg});
    });

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onSuccess();
    });

    runCode(mockData);

    assertThat(callInWindowArgs.length).isEqualTo(1);
    assertThat(callInWindowArgs[0].fn).isEqualTo('varify.setTracking');
    assertThat(callInWindowArgs[0].arg).isEqualTo(true);
    assertApi('gtmOnSuccess').wasCalled();

- name: Consent mode enabled - setTracking not called immediately
  code: |-
    const mockData = {
      instanceId: '12345',
      consentMode: true,
      debug: false
    };

    mock('copyFromWindow', function(key) {
      if (key === 'varify') return { setTracking: function() {} };
      return undefined;
    });

    mock('setInWindow', function() {});

    let callInWindowCalled = false;
    mock('callInWindow', function() {
      callInWindowCalled = true;
    });

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onSuccess();
    });

    runCode(mockData);

    assertThat(callInWindowCalled).isFalse();
    assertApi('gtmOnSuccess').wasCalled();

- name: Script failure calls gtmOnFailure
  code: |-
    const mockData = {
      instanceId: '12345',
      consentMode: false,
      debug: false
    };

    mock('copyFromWindow', function() { return undefined; });
    mock('setInWindow', function() {});

    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      onFailure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
