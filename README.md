# GKPictureInPictureView

[![CI Status](https://img.shields.io/travis/gklka/GKPictureInPictureView.svg?style=flat)](https://travis-ci.org/gklka/GKPictureInPictureView)
[![Version](https://img.shields.io/cocoapods/v/GKPictureInPictureView.svg?style=flat)](https://cocoapods.org/pods/GKPictureInPictureView)
[![License](https://img.shields.io/cocoapods/l/GKPictureInPictureView.svg?style=flat)](https://cocoapods.org/pods/GKPictureInPictureView)
[![Platform](https://img.shields.io/cocoapods/p/GKPictureInPictureView.svg?style=flat)](https://cocoapods.org/pods/GKPictureInPictureView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objectivec
// Your gorgeous content view
UIView *contentView = [UIView new];
contentView.backgroundColor = [UIColor redColor];

// Init Picture in Picture view
self.pipView = [[GKPictureInPictureView alloc] initWithContentView:contentView];

// Show it
[self.pipView addToSuperView:self.blue animated:YES];
```

![Example](https://media.giphy.com/media/3GBKcqOnBnm0D6OnK8/giphy.gif)

## Requirements

iOS 10

## Installation

GKPictureInPictureView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GKPictureInPictureView'
```

## Usage

GKPictureInPictureView can be used either by initializing it from code (see the Example above) or by using Storyboards.

### Code

1. Create your content view. It will be constrainted to the draggable view's edges, so don't add any constraints which can conflict with the size or position
2. Create a GKPictureInPictureView and init it with `-initWithContentView:`
3. Add it to your superview: `-addToSuperView:animated:`.

### Storyboards

1. Create a `UIView`. You can create whatever subviews you want, but don't set any constraints to width, height and position
2. Change the class of the view to `GKPictureInPictureView`

### Finetuning

There are plenty of options you can choose from. For example you can prevent the view to go to certain edges by setting NO on options like `bottomLeftPositionEnabled`. You can also disable zooming. See [GKPictureInPictureView.h](https://github.com/gklka/GKPictureInPictureView/blob/master/GKPictureInPictureView/Classes/GKPictureInPictureView.h) headers for details.

## Author

gklka, gk@lka.hu

## License

GKPictureInPictureView is available under the MIT license. See the LICENSE file for more info.
