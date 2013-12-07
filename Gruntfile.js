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
            bookmarks: {
                files: {
                    'static/js/<%= pkg.name %>.min.js': ['static/js/<%= pkg.name %>.js']
                }
            },
            libs: {
                files: {
                    'static/js/<%= pkg.name %>-libs.min.js': ['static/lib/lodash.min.js', 'static/lib/qwest.js']
                }
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
                    'static/css/<%= pkg.name %>.css': 'static/sass/<%= pkg.name %>.sass'
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
