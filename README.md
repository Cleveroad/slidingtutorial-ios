# CRSlidingTutorial [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome) <img src="https://www.cleveroad.com/public/comercial/label-ios.svg" height="20"> <a href="https://www.cleveroad.com/?utm_source=github&utm_medium=label&utm_campaign=contacts"><img src="https://www.cleveroad.com/public/comercial/label-cleveroad.svg" height="20"></a>

![Header image](/images/header.jpg)

## Cleveroad is glad to introduce CRSliding Tutorial for iOS

Hello, everyone! Do you remember our [Sliding tutorial for Android](https://github.com/Cleveroad/SlidingTutorial-Android) apps? Then, we’ve got great new for you! Our team has taken into account your feedback and your wish to have the same on iOS and, ta-da, here is your Sliding tutorial library for iPhone and iPad apps. We made creation of unique and smart tutorials go simple and straightforward.

![Demo image](/images/demo.gif)

Google-stylized and equipped with parallax effects, the library will help your app make unforgettable first impression. So, what are you waiting for?

If you want to have this tutorial in your app, all you have to do is to adhere to your brand style — colors, images, text, and follow our instructions. 
 

[![Awesome](/images/logo-footer.png)](https://www.cleveroad.com/?utm_source=github&utm_medium=label&utm_campaign=contacts)
<br/>
## Usage

Add to your Podline a line  <br>
```c
pod 'SlidingTutorial'
``` 

Run in terminal command <br>
```c
$ pod install
```

Then import PRLView.h to your view controller:<br>
```c
#import "PRLView.h"
```

After you should instantiate an instance of sliding view tutorial class: <br>

```c
PRLView *viewParallax = [[PRLView alloc] initWithViewsFromXibsNamed:@[@"TestView", @"TestView1", @"TestView2"] infiniteScroll:YES delegate:self];
```

Where first parameter is an array of xib's names tou want to setup to your tutorial, second parameter is a boolean - set YES if you want endless scroll and third parameter is an object's delegate 

**slippingCoefficient** - (Sets in interface builder) ratio bound to scroll offset in scroll view. For 1 pixel content offset of scroll view layer will be slipping for `1 * slippingCoefficient` (so if `slippingCoefficient == 0.3`, it will be equal `0.3px`). Sign determines the direction of slipping - left or right. 

After all call last method - prepareForShow: 
```c
[viewParallax prepareForShow];
```
And now your tutorial is ready to show. 

For handle skip button action, you should support **PRLViewProtocol**  and implement protocol method **skipTutorial**

## Support
If you have any questions, issues or propositions, please create a <a href="../../issues/new">new issue</a> in this repository.

If you want to hire us, send an email to sales@cleveroad.com or fill the form on <a href="https://www.cleveroad.com/contact">contact page</a>

Follow us:

[![Awesome](/images/social/facebook.png)](https://www.facebook.com/cleveroadinc/)   [![Awesome](/images/social/twitter.png)](https://twitter.com/cleveroadinc)   [![Awesome](/images/social/google.png)](https://plus.google.com/+CleveroadInc)   [![Awesome](/images/social/linkedin.png)](https://www.linkedin.com/company/cleveroad-inc-)   [![Awesome](/images/social/youtube.png)](https://www.youtube.com/channel/UCFNHnq1sEtLiy0YCRHG2Vaw)

## License

Copyright (С) 2016 Cleveroad

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

http://choosealicense.com/licenses/gpl-2.0/

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
