The controllers and views of this project may be used to easily create interfaces much like Apple's Settings applications. They make up most of the UI of the free [LocrUpload application](http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=307805480&mt=8).

The PropertiesViewController may be used to modify attributes of any key-value-coding compliant container. Typically a container would be a NSMutableDictionary or a NSUserDefaults instance.

The controller is typically configured in a subclass by providing a set of descriptors. Descriptors are immutable objects describe the properties to expose and the UI elements (text field, switch, ...) to use. Seeing that descriptors are immutable, it should be easy to store them in a file rather than building them in code.

The SelectionViewController is used by the PropertiesViewController for multiple choice values.