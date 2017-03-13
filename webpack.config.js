
const ENV = process.env.WEBPACK_ENV || 'dev';

console.log("\r\n\r\n ============================\r\n\r\n");
console.log(" Environment: " + ENV);
console.log("\r\n\r\n ============================\r\n\r\n");

const path = require("path");
const webpack = require("webpack");

const autoprefixer = require("autoprefixer");
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require("html-webpack-plugin");
const ProgressBarPlugin = require('progress-bar-webpack-plugin');
const ngAnnotatePlugin 	= require('ng-annotate-webpack-plugin');
const WebpackErrorNotificationPlugin = require('webpack-error-notification');
const CleanWebpackPlugin = require('clean-webpack-plugin');


const plugins =  []
	
	
if ( ENV === 'build' || ENV === 'prod' ) {

	plugins.push(

		new ProgressBarPlugin({
			format: '🐢  build [:bar] [:percent] [:elapsed seconds] :msg',
			clear: false, 
		}),

	 	new ngAnnotatePlugin({
        add: true,
    }),

		new webpack.optimize.UglifyJsPlugin({

			// exclude: /\.release\.css/i,

			beautify: false,
			comments: false,
			compress: {
				sequences: true,
				booleans: true,
				loops: true,
				unused: true,
				warnings: false,
				drop_console: false,
				unsafe: true
			}
		}),

		new ExtractTextPlugin('bundles/[name]/[name].css?[hash]', {
			allChunks: false,
		}),

		new CleanWebpackPlugin(['htdocs'],{
  		"exclude": [
  			"readme.txt"
  		]
		})

	);

}

if ( ENV === 'prod' || ENV === 'dev' ) {

	plugins.push(

		new WebpackErrorNotificationPlugin()

	)

}

if ( ENV === 'dev' ) {


}


var config = {

		devtool: ( ENV === 'dev' ) ? 'source-map' : 'cheap-module-source-map',
		entry: {
			'styles': "./frontend/app/libs.styles.coffee",
			'scripts': "./frontend/app/libs.scripts.coffee",
			'app': "./frontend/app/app.coffee",
		},

		output:  {
			path: './htdocs/',
			publicPath:  ( ENV === 'dev') ? "http://localhost:8888/" : "/" ,
			filename:
				( ENV === 'build' || ENV === 'prod' )
				? "bundles/[name]/[name].min.js?[hash]"
				: "bundles/[name]/[name].js?[hash]",

			chunkFilename:
				( ENV === 'build' || ENV === 'prod' )
				? "chunks/[name]/[name].min.js?[hash]"
				: "chunks/[name]/[name].js?[hash]",
		},

		plugins: plugins.concat(

			[

				new webpack.optimize.CommonsChunkPlugin({
					name: 'core',
					chunks: ["styles","scripts","app"]
				}),

				new HtmlWebpackPlugin({
					inject: 'head',
					template: './frontend/app/index.pug',
					filename: './index.html',
				}),


			]

		),

		module: {


			loaders: [

				{
	        test: /\.js$/,
	        exclude: [
	        	path.resolve(__dirname, './node_modules/'),
	        ],
	        loader:  'babel-loader',
	        query: {
		        presets: ['es2015']
		      }
	      },

				{
					test: /\.html$/,
					loader: 'html-loader'
				},

				{
					test: /\.pug$/,
					loader:
						( ENV === 'build' || ENV === 'prod' )
						? 'pug-loader'
						: 'pug-loader?pretty',
				},

				{
					test: /\.coffee$/,
					loader: "coffee-loader"
				},


				{
					test: /\.styl$/,
					loader:
						( ENV === 'build' || ENV === 'prod' )
						? ExtractTextPlugin.extract('style-loader', 'css-loader?minimize&-autoprefixer!postcss-loader!stylus-loader')
						: 'style-loader!css-loader?sourceMap!postcss-loader!stylus-loader',
				},

				{
					test: /\.css$/,
					loader:
						( ENV === 'build' || ENV === 'prod' )
						? ExtractTextPlugin.extract('style-loader', 'css-loader?minimize&-autoprefixer!postcss-loader')
						: 'style-loader!css-loader?sourceMap!postcss-loader'
				},

				{
					test: /\.(jpe?g|png|gif|ico|cur)$/i,
					exclude: [
						path.resolve(__dirname, './node_modules/'),
					],
					loaders: 
						( ENV === 'build' || ENV === 'prod' )
						?	
							[								
								'image-webpack-loader?bypassOnDebug&optimizationLevel=7&interlaced=false',
								'file-loader?hash=sha512&context=frontend/app&name=[path][name].[ext]?[hash]'
							]
						:
							[
								'file-loader?hash=sha512&context=frontend/app&name=[path][name].[ext]?[hash]'
							]
					
				},

				
				{
					test: /\.(otf|ttf|eot|woff|woff2|svg)$/,
					exclude: [
						path.resolve(__dirname, './node_modules/'),
					],
					loader: 'file-loader?hash=sha512&context=frontend/app&name=assets/fonts/[name].[ext]',
				},

				{
					test: /\.(pdf)$/,
					exclude: [
						path.resolve(__dirname, './node_modules/'),
					],
					loader: 'file-loader?hash=sha512&context=frontend/app&name=assets/pdf/[name].[ext]?[hash]',
				},


				{
					test: /\.(swf)$/,
					exclude: [
						path.resolve(__dirname, './node_modules/'),
					],
					loader: 'file-loader?hash=sha512&context=frontend/app&name=assets/swf/[name].[ext]?[hash]',
				},


				// NODE MODULES!
				{
					test: /\.(jpe?g|png|gif|svg|otf|ttf|eot|woff|woff2)$/i,
					exclude: [
						path.resolve(__dirname, './frontend/')
					],
					loader: 'file-loader?hash=sha512&context=node_modules&name=assets/[path][name].[ext]?[hash]'
					
				},

			],

		},

		stylus: {
	    import: [
	      '~stylMixins/basic.styl',
	      '~stylMixins/adaptive.styl',
	      '~stylMixins/app.styl',
	    ],
	  },

		postcss: function () {
			
			return [
				autoprefixer({
					browsers: [
						'last 3 version',
						'Firefox < 20',
						'ie 9'
					]
				}),
			];

		},


		resolve: {

			alias: {

				node_modules: path.resolve(__dirname, './node_modules'),

				root: path.resolve(__dirname, './frontend'),
				app: path.resolve(__dirname, './frontend/app'),

				includes: path.resolve(__dirname, './frontend/app/includes'),
				partials: path.resolve(__dirname, './frontend/app/partials'),
				components: path.resolve(__dirname, './frontend/app/components'),
				pages: path.resolve(__dirname, './frontend/app/pages'),
				popups: path.resolve(__dirname, './frontend/app/popups'),
				directives: path.resolve(__dirname, './frontend/app/directives'),
				services: path.resolve(__dirname, './frontend/app/services'),

				assets: path.resolve(__dirname, './frontend/app/assets'),
				js: path.resolve(__dirname, './frontend/app/assets/js'),
				css: path.resolve(__dirname, './frontend/app/assets/css'),
				img: path.resolve(__dirname, './frontend/app/assets/img'),
				fonts: path.resolve(__dirname, './frontend/app/assets/fonts'),
				pdf: path.resolve(__dirname, './frontend/app/assets/pdf'),

				stylMixins: path.resolve(__dirname, './frontend/app/stylus-mixins'),

			}

		},


		devServer: {

			port: 8888,

			contentBase: './htdocs',

			proxy: {
				'/api/*': {
						target: 'http://new.test.dev.ailove.ru',
						changeOrigin: true
				 },
			},

			historyApiFallback: {
				rewrites: [
					{ from: /^\/$/, to: '/htdocs/index.html' },
					// { from: /./, to: '' },
				]
			},

		},



}


module.exports = config;