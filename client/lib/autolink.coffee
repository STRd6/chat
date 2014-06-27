dataRegex = /data:image\/[^\s]*/

# Autolinks dataurls as images
# TODO V2: Autolink other urls?
@autolink = (element) ->
  element.innerHTML = element.textContent.replace(dataRegex, '<img src="$&" />')
