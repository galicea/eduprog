var gulp = require('gulp');
var webpack = require('webpack-stream');
//var minify = require('gulp-minify'); // webpack UglifyJsPlugin()

var path = {
  HTML: 'public/index.html',
  CSS: 'src/*.css',
  PUBLIC: 'public/*.*',
  DEST: 'dist'
};

var webpackConfig = require('./webpack.config.js');


gulp.task('webpack', function() {
//   console.log(webpackConfig); - tablica - dlatego [0] poniżej
   var watch = Object.create(webpackConfig[0]);
//   console.log(watch);
//   watch.watch = true;
   return gulp.src('src/index.js')
        .pipe(webpack(watch))
//        .pipe(minify())
        .pipe(gulp.dest(path.DEST));
});

gulp.task('public', function() {
  return gulp.src(path.PUBLIC)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('css', function() {
  return gulp.src(path.CSS)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('build', ['webpack', 'css', 'public'], function() {
  console.log('Zbudowany!');
});
gulp.task('default', ['build']);
