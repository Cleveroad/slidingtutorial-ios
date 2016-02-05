##Sliding Tutorial iOS [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)  <a href="https://www.cleveroad.com/?utm_source=github&utm_medium=label&utm_campaign=contacts"><img src="https://www.cleveroad.com/public/comercial/label-cleveroad.svg" height="20"></a>

###Simple library that helps developers to create awesome sliding iOS app tutorial.

Applied parallax effects will make your product presentation look like Google apps tutorial.

All you need to do is:
<br>1. Create icons for each screen of your tutorial
<br>2. Follow the instructions below

## Usage

Add to your Podline a line  <br>
`pod 'SlidingTutorial'` 

Run in terminal command <br>
`$ pod install`

Then import PRLView.h to your view controller:<br>
`#import "PRLView.h"`

After you should instantiate an instance of sliding view tutorial class: <br>

`PRLView *viewParallax = [[PRLView alloc] initWithPageCount:3 scaleCoefficient:0.8];`

Where first parameter is a count of pages in tutorial and second parameter is a coefficient of  scaling images (put 1.0 if you don't need scale and images will  displaying in a full size).  <br>

Then add background colors for all your tutorial pages: <br>
`[viewParallax addBackgroundColor:[UIColor colorWithRed:231./255 green:150./255 blue:0 alpha:1]];` <br>
`[viewParallax addBackgroundColor:[UIColor colorWithRed:163./255 green:181./255 blue:0 alpha:1]];` <br>
`[viewParallax addBackgroundColor:[UIColor colorWithRed:35./255 green:75./255 blue:122.0/255 alpha:1]];` <br>

<p>The colors follow the order they are added. All missing colors will be replaced with white color.  </p>

After that you should add all image-layers onto sliding tutorial view: <br>
`[viewParallax addElementWithName:@"elem00-00" offsetX:0 offsetY:0 slippingCoefficient:0.3 pageNum:0];`<br>
`[viewParallax addElementWithName:@"elem01-00" offsetX:-140 offsetY:25 slippingCoefficient:-0.15 pageNum:1];` <br>
`[viewParallax addElementWithName:@"elem02-00" offsetX:-50 offsetY:-120 slippingCoefficient:0.2 pageNum:2];`<br>

**First param** - image name from your project resources. <br>

**offsetX** and **offsetY** - layer offset from the center of the screen. If you send  offsetX:0 offsetY:0 your image layer will be placed exactly in the center of the screen. Dot (0,0) in this coords system situated in the center of the screen in all device orientations.  <br>

**slippingCoefficient** - ratio bound to scroll offset in scroll view.  For 1 pixel content offset of scroll view layer will be slipping for 1 * slippingCoefficient (so if  slippingCoefficient == 0.3, it will be equal 0.3px). Sign determines the direction of slipping - left or right. <br>

**pageNum** - the page number on which you will add this image layer. <br>

After all call last method - prepareForShow: <br>
`[viewParallax prepareForShow];` <br>
And now your tutorial is ready to show. <br>

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

Copyright (С) 2015 Cleveroad

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
