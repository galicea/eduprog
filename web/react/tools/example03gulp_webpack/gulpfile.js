var gulp = require('gulp');
var webpack = require('webpack-stream');

var path = {
  HTML: 'public/index.html',
  JS: ['src/js/*.js', 'src/js/**/*.js'],
  JSX: ['src/*.jsx'],
  REACT_SRC: 'node_modules/react/dist/react.min.js',
  REACT_DOM_SRC: 'node_modules/react-dom/dist/react-dom.min.js',
  DEST: 'dist',
  DEST_JS: 'dist/js'
};


gulp.task('webpack', function() {
  return gulp.src('src/index.js')
    .pipe(webpack( require('./webpack.config.js') ))
    .pipe(gulp.dest(path.DEST_JS));
});


gulp.task('html', function() {
  return gulp.src(path.HTML)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('build', ['webpack', 'html'], function() {
  console.log('Zbudowany!');
});
gulp.task('default', ['build']);