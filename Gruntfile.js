module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            options: {
                bare: true
            },
            build: {
                src: 'coffee/*.coffee',
                dest: 'static/js/<%= pkg.name %>.js'
            }
        },
        sass: {
            dist: {
                options: {
                    style: 'compressed'
                },
                files: {
                    'static/css/<%= pkg.name %>.css': 'sass/<%= pkg.name %>.sass'
                },
                flags: [
                    '--minify'
                ]
            }
        },
        uglify: {
            tassel: {
                files: {
                    'static/js/<%= pkg.name %>.min.js': ['static/js/<%= pkg.name %>.js']
                }
            },
            libs: {
                files: {
                    'static/js/<%= pkg.name %>-libs.min.js': ['static/lib/lodash.js', 'static/lib/qwest.js']
                }
            }
        },
        watch: {
            files: ['<%= coffee.build.src %>', 'static/js/<%= pkg.name %>.js', 'static/sass/*.sass'],
            tasks: ['coffee', 'uglify', 'sass']
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-sass');

    grunt.registerTask('default', ['coffee', 'sass', 'watch']);
};
