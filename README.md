# Ti.AirPrint Module

Exposes the AirPrint API to Appcelerator Titanium applications.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.AirPrint Module

To access this module from JavaScript, you would do the following:

```js
var AirPrint = require('ti.airprint');
```

## APIs

### Methods

#### print(args)

Prints a document by showing a popover on the iPad or a modal window on other iOS devices.

##### Arguments

Takes one argument, a dictionary with the following keys:

* url[string]: The URL to an image or PDF. Can be local or remote, but must be accessible to the app.
* showsPageRange[boolean] (optional): Whether or not to show the page range selector in the popover (Deprecated, always `true`).
* showsNumberOfCopies[boolean] (optional): Whether or not to show the number of copies (Default: `true`)
* showsPaperSelectionForLoadedPapers[boolean] (optional): Paper selection for loaded papers is always shown for photo-outputes and grayscale photo outputs. Default: `false`
* view[object] (optional): On the iPad, the object from which the popover should originate.

#### canPrint()

Returns whether or not the current device supports printing. Note that a printer does not need to be attached for this to return true.

### Events

- `open`
- `close`
- `select`

## Usage

See example.

## License

Copyright(c) 2010-present by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.
