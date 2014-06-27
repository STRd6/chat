@extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target
