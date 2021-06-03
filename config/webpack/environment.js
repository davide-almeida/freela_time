const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    // $: 'jquery/src/jquery',
    // jQuery: 'jquery/src/jquery'
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    // Rails: '@rails/ujs',
    Toastify: 'toastify-js/src/toastify'
  })
)

module.exports = environment
