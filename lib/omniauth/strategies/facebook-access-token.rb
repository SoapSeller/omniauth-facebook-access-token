require 'oauth2'
require 'omniauth'

module OmniAuth
  module Strategies
    class FacebookAccessToken
      include OmniAuth::Strategy

      option :name, 'facebook_access_token'

      args [:client_id, :client_secret]

      option :client_id, nil
      option :client_secret, nil

      option :client_options, {
        :site => 'https://graph.facebook.com',
        :token_url => '/oauth/access_token'
      }

      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }

      attr_accessor :access_token

      uid { raw_info['id'] }

      info do
        prune!({
          'nickname' => raw_info['username'],
          'email' => raw_info['email'],
          'name' => raw_info['name'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'image' => image_url(uid, options),
          'description' => raw_info['bio'],
          'urls' => {
            'Facebook' => raw_info['link'],
            'Website' => raw_info['website']
          },
          'location' => (raw_info['location'] || {})['name'],
          'verified' => raw_info['verified']
        })
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        prune! hash
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.expires? && access_token.refresh_token
        hash.merge!('expires_at' => access_token.expires_at) if access_token.expires?
        hash.merge!('expires' => access_token.expires?)
        hash
      end

      def raw_info
        @raw_info ||= access_token.get('/me', info_options).parsed || {}
      end

      def info_options
        options[:info_fields] ? {:params => {:fields => options[:info_fields]}} : {}
      end

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def request_phase
        form = OmniAuth::Form.new(:title => "User Token", :url => callback_path)
        form.text_field "Access Token", "access_token"
        form.button "Sign In"
        form.to_response
      end

      def callback_phase
        if !request.params['access_token'] || request.params['access_token'].to_s.empty?
          raise ArgumentError.new("No access token provided.")
        end

        self.access_token = build_access_token
        self.access_token = self.access_token.refresh! if self.access_token.expired?

        # Validate that the token belong to the application
        app_raw = self.access_token.get('/app').parsed
        if app_raw["id"] != options.client_id.to_s
          raise ArgumentError.new("Access token doesn't belong to the client.")
        end

        # Instead of calling super, duplicate the functionlity, but change the provider to 'facebook'.
        # This is done in order to preserve compatibilty with the regular facebook provider
        hash = auth_hash
        hash[:provider] = "facebook"
        self.env['omniauth.auth'] = hash
        call_app!

       rescue ::OAuth2::Error => e
         fail!(:invalid_credentials, e)
       rescue ::MultiJson::DecodeError => e
         fail!(:invalid_response, e)
       rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
         fail!(:timeout, e)
       rescue ::SocketError => e
         fail!(:failed_to_connect, e)
      end

      protected

      def deep_symbolize(hash)
        hash.inject({}) do |h, (k,v)|
          h[k.to_sym] = v.is_a?(Hash) ? deep_symbolize(v) : v
          h
        end
      end

      def build_access_token
        # Options supported by `::OAuth2::AccessToken#initialize` and not overridden by `access_token_options`
        hash = request.params.slice("access_token", "expires_at", "expires_in", "refresh_token")
        hash.update(options.access_token_options)
        ::OAuth2::AccessToken.from_hash(
          client,
          hash
        )
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def image_url(uid, options)
        uri_class = options[:secure_image_url] ? URI::HTTPS : URI::HTTP
        url = uri_class.build({:host => 'graph.facebook.com', :path => "/#{uid}/picture"})

        query = if options[:image_size].is_a?(String)
          { :type => options[:image_size] }
        elsif options[:image_size].is_a?(Hash)
          options[:image_size]
        end
        url.query = Rack::Utils.build_query(query) if query

        url.to_s
      end
    end
  end
end
