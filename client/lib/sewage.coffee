if location.hash
  @ENV = JSON.parse Base64.decode(location.hash.substring(1))
else
  @ENV = {}
