var gulp = require('gulp');
var webpack = require('webpack-stream');
var minify = require('gulp-minify');

var path = {
  HTML: 'src/index.html',
  CSS: 'src/*.css',
  JS: ['src/js/*.js', 'src/js/**/*.js'],
  JSX: ['src/*.jsx'],
  REACT_SRC: 'node_modules/react/dist/react.min.js',
  REACT_DOM_SRC: 'node_modules/react-dom/dist/react-dom.min.js',
  DEST: 'dist',
  DEST_WP: 'dist'
};

var webpackConfig = require('./webpack.config.js');


gulp.task('webpack', function() {
//   console.log(webpackConfig); - tablica - dlatego [0] poniżej
   var watch = Object.create(webpackConfig[0]);
//   console.log(watch);
//   watch.watch = true;
   return gulp.src('src/index.js')
        .pipe(webpack(watch))
//      .pipe(minify()) ->  uglifyjs-webpack-plugin  
        .pipe(gulp.dest(path.DEST_WP));
});

gulp.task('html', function() {
  return gulp.src(path.HTML)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('css', function() {
  return gulp.src(path.CSS)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('build', ['webpack', 'css', 'html'], function() {
  console.log('Zbudowany!');
});
gulp.task('default', ['build']);
