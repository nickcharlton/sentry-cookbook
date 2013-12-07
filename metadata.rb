name             'sentry'
maintainer       'Nick Charlton'
maintainer_email 'nick@nickcharlton.net'
license          'MIT'
description      'Installs and configures the error logging and aggregation tool, Sentry.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

depends 'python'
depends 'postgres'
depends 'runit'
depends 'nginx'

