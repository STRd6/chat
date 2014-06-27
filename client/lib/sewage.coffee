if location.hash
  @ENV = JSON.parse location.hash.substring(1)
else
  @ENV = {}
