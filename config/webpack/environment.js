const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

const HandlebarsLoader = {
    test: /\.hbs$/,
    loader: 'handlebars-loader'
}

environment.loaders.append('hbs', HandlebarsLoader)

module.exports = environment
