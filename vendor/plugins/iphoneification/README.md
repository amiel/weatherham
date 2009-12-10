# iphoneification

A Rails plugin which lets your app serve custom content to iPhone and iPod Touch users.

## Usage

    script/plugin install git://github.com/jameswilding/iphoneification.git
	
    class ApplicationController
      responds_to_iphone
    end

Name your views and layouts {name}.iphone.erb. Skip iphonification with <code>skip_iphone_response</code>. The <code>responds_to_iphone and skip_iphone_response</code> methods takes the same options as <code>before_filter</code> and <code>skip_before_filter</code>, respectively: see [api.rubyonrails.org][api] for more details.

## More

Original blog post at	[http://jameswilding.net/2009/08/10/iphone-on-rails/][blog].

## Credit

Based on [an article from slashdotdash.net][slash].

## Copyright

Copyright (c) 2009 James Wilding, released under the MIT license.

[api]: http://api.rubyonrails.org/
[blog]: http://jameswilding.net/2009/08/10/iphone-on-rails/
[slash]: http://www.slashdotdash.net/2007/12/04/iphone-on-rails-creating-an-iphone-optimised-version-of-your-rails-site-using-iui-and-rails-2/