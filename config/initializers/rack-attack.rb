class Rack::Attack
  self.blacklist('allow2ban login scrapers') do |req|
    # `filter` returns false value if request is to your login page (but still
    # increments the count) so request below the limit are not blocked until
    # they hit the limit.  At that point, filter will return true and block.
    Rack::Attack::Allow2Ban.filter('logins/email', :maxretry => 4, :findtime => 1.minute, :bantime => 1.minute) do
      # The count for the IP is incremented if the return value is truthy.
      req.post? && req.path == "/sessions" && req.params['user']['email']
    end
  end

  self.blacklisted_response = lambda do |env|
    env['rack.attack.blacklisted'] # name of the matched blacklist
    [ 503, {}, [
      '<h1>You have attempted to login too many times.</h1>
      <h3>You must wait 1 minute before you can try again.</h3>']]
  end
end
