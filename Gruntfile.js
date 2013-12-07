module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            options: {
                bare: true
            },
            build: {
                src: 'static/coffee/*.coffee',
                dest: 'static/js/<%= pkg.name %>.js'
            }
        },
        uglify: {
            build: {
                src: 'static/js/<%= pkg.name %>.js',
                dest: 'static/js/<%= pkg.name %>.min.js'
            }
        },
        lodash: {
            options: {
                modifier: 'modern'
            },
            build: {
                dest: 'static/lib/lodash.js'
            }
        },
        sass: {
            dist: {
                options: {
                    style: 'compressed'
                },
                files: {
                    'static/css/bookmarks.css': 'static/sass/bookmarks.sass'
                },
                flags: [
                    '--minify'
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-lodash');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-sass');

    grunt.registerTask('default', ['lodash', 'coffee', 'uglify', 'sass']);
};
