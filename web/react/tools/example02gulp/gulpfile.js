var gulp = require('gulp');
var babel = require('gulp-babel');

var path = {
  HTML: 'src/index.html',
  JSX: ['src/*.jsx'],
  REACT_SRC: 'node_modules/react/umd/react.production.min.js',
  REACT_DOM_SRC: 'node_modules/react-dom/umd/react-dom.production.min.js',
  DEST: 'dist',
  DEST_JS: 'dist/js'
};

function copyReact() {
  return gulp.src(path.REACT_SRC)
    .pipe(gulp.dest(path.DEST_JS));
}

function copyReactDom() {
  return gulp.src(path.REACT_DOM_SRC)
    .pipe(gulp.dest(path.DEST_JS));
}

function jsx() {
  return gulp.src(path.JSX)
    .pipe(babel({
      presets: ['@babel/preset-react']
    }))
    .pipe(gulp.dest(path.DEST_JS));
}

function html() {
  return gulp.src(path.HTML)
    .pipe(gulp.dest(path.DEST));
}

var build = gulp.parallel(gulp.series(copyReact, copyReactDom), html, jsx);
gulp.task('build', build);
gulp.task('default', build);