# OmniAuth Facebook Access Token

Facebook Access Token Strategy for OmniAuth 1.0.

Supports client-side flow only. And fully compatible with [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook).
(Auth Hash is the same & etc')

Read the Facebook docs for more details: https://developers.facebook.com/docs/concepts/login/

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-facebook-access-token'
```

Then `bundle install`.

## Usage

### Server-Side
`OmniAuth::Strategies::FacebookAccessToken` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook_access_token, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
end
```

### Client-Side

Login via ajax GET/POST call to `/auth/facebook_access_token/callback` while providing `access_token` parameter.

## License

Copyright (c) 2012 by Dor Shahaf

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
