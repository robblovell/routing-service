var coffee, coffeeFiles, gulp, gutil, handleError, jade, jadeFiles, parallelize, path, sh, sourcemaps, stylus, stylusFiles, tap, threads, touch, useSourceMaps;

gulp = require('gulp');

gutil = require('gulp-util');

coffee = require('gulp-coffee');

sourcemaps = require('gulp-sourcemaps');

touch = require('touch');

path = require('path');

tap = require('gulp-tap');

sh = require('shelljs');

jade = require('gulp-jade');

stylus = require('gulp-stylus');

parallelize = require("concurrent-transform");

threads = 100;

useSourceMaps = true;

coffeeFiles = ['**/*.coffee'];

jadeFiles = ['./views/**/*.jade'];

stylusFiles = ['./public/stylesheets/**/*.styl'];

handleError = function(err) {
  console.log(err.toString());
  return this.emit('end');
};

gulp.task('touch', function() {
  return gulp.src(coffeeFiles).pipe(tap(function(file, t) {
    return touch(file.path);
  }));
});

gulp.task('coffeescripts', function() {
  return gulp.src(coffeeFiles).pipe(sourcemaps.init()).pipe(parallelize(coffee({
    bare: true
  }).on('error', gutil.log), threads)).pipe(parallelize(sourcemaps.write('./'), threads)).pipe(parallelize(gulp.dest(function(file) {
    return file.base;
  }), threads));
});

gulp.task('one', function() {
  return gulp.src('./css/one.styl').pipe(stylus()).pipe(gulp.dest('./css/build'));
});

gulp.task('watch', function() {
  return gulp.watch(coffeeFiles, ['coffeescripts']);
});

gulp.task('build', ['coffeescripts']);

gulp.task('default', ['watch', 'coffeescripts']);

gulp.task('done', (function() {}));

//# sourceMappingURL=gulpfile.js.map
