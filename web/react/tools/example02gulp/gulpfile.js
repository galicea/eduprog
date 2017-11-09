var gulp = require('gulp');
var babel = require('gulp-babel');

var path = {
  HTML: 'src/index.html',
  JS: ['src/js/*.js', 'src/js/**/*.js'],
  JSX: ['src/*.jsx'],
  REACT_SRC: 'node_modules/react/dist/react.min.js',
  REACT_DOM_SRC: 'node_modules/react-dom/dist/react-dom.min.js',
  DEST: 'dist',
  DEST_JS: 'dist/js'
};

gulp.task('copy-react', function() {
  return gulp.src(path.REACT_SRC)
    .pipe(gulp.dest(path.DEST_JS));
});

gulp.task('copy-react-dom', function() {
  return gulp.src(path.REACT_DOM_SRC)
    .pipe(gulp.dest(path.DEST_JS));
});

gulp.task('jsx', function() {
  return gulp.src(path.JSX)
    .pipe(babel({
      presets: ["react", 'es2015']
    }))
    .pipe(gulp.dest(path.DEST_JS));
});

gulp.task('html', function() {
  return gulp.src(path.HTML)
    .pipe(gulp.dest(path.DEST));
});

gulp.task('build', ['copy-react', 'copy-react-dom', 'html', 'jsx'], function() {
  console.log('Zbudowany!');
});
gulp.task('default', ['build']);