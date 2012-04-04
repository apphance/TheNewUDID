# Persistent UDID Generator for iOS Applications

## Description

TheNewUDID is intended to be a drop-in replacement for deprecated iOS UDID API. The generated UDID is available only for the application that created it, 
however it is fully persisent and will not be removed when user removes your application. The UDID is stored within iOS Keychain, which is backed up in
both iTunes and iCloud, thus it ensures that your app will never loose a once-generated UDID (unless user wipes device and doesn't restore it using iCloud/iTunes). 

## Usage

Just copy <code>TNUAppSpecificUDID.h</code> and <code>TNUAppSpecificUDID.m</code> into your project, add <code>Security.framework</code>
to list of linked libraries adn you're ready to go!

## Future

Currently TheNewUDID supports per-app UDID generation and persistance. Future releases will add application-group
UDID support (based on <a href="https://developer.apple.com/library/mac/#documentation/security/conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html#//apple_ref/doc/uid/TP30000897-CH208-SW1">Shared Keychain</a> implementation). 

## MIT License

Copyright (c) 2012 Apphance (www.apphance.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
