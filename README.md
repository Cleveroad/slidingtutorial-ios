##Sliding Tutorial iOS [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)  <a href="https://www.cleveroad.com/?utm_source=github&utm_medium=label&utm_campaign=contacts"><img src="https://www.cleveroad.com/public/comercial/label-cleveroad.svg" height="20"></a>

###Simple library that helps developers to create awesome sliding iOS app tutorial.

Applied parallax effects will make your product presentation look like Google apps tutorial.

All you need to do is:
<br>1. Create xibs for each screen of your tutorial
<br>2. Follow the instructions below

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

**slippingCoefficient** - (Sets in interface builder) ratio bound to scroll offset in scroll view. For 1 pixel content offset of scroll view layer will be slipping for 1 * slippingCoefficient (so if slippingCoefficient == 0.3, it will be equal 0.3px). Sign determines the direction of slipping - left or right. 

After all call last method - prepareForShow: 
```c
[viewParallax prepareForShow];
```
And now your tutorial is ready to show. 

For handle skip button action, you should support **PRLViewProtocol**  and implement protocol method **skipTutorial**

## Support
If you have any questions regarding the use of this tutorial, please contact us for support
at info@cleveroad.com (email subject: «Sliding iOS app tutorial. Support request.»)
<br>or
<br>Use our contacts:
<br><a href="https://www.cleveroad.com/?utm_source=github&utm_medium=link&utm_campaign=contacts">Cleveroad.com</a>
<br><a href="https://www.facebook.com/cleveroadinc">Facebook account</a>
<br><a href="https://twitter.com/CleveroadInc">Twitter account</a>
<br><a href="https://plus.google.com/+CleveroadInc/">Google+ account</a>

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
