# outsystems-resources-plugin
Enables the use of files added as resources in an OutSystems app


## Usage
The file name to be fetched is passed as the first parameter.
The Documents folder, in the app sandbox, will be the place the files will be copied to.

```
cordova.plugins.OutSystemsResources.getFile("outsystems.png",function(success){},function(error){});
```

Android: Under Development