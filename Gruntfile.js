module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            compile: {
                options: {
                    bare: true,
                },
                files: {
                    'static/js/<%= pkg.name %>.js': [
                        'coffee/*.coffee',
                        'coffee/*/*.coffee',
                    ]
                }
            }
        },
        codo: {
            options: {
                title: "Tassel. Simple bookmarks server",
                output: 'docs',
                inputs: [
                    'coffee'
                ]
            }
        },
        stylus: {
            compile: {
                files: {
                    'static/css/<%= pkg.name %>.css': 'stylus/<%= pkg.name %>.styl',
                }
            }
        },
        uglify: {
            tassel: {
                files: {
                    'static/js/<%= pkg.name %>.min.js': [
                        'static/js/<%= pkg.name %>.js',
                    ]
                }
            },
            libs: {
                files: {
                    'static/js/<%= pkg.name %>-libs.min.js': [
                        'static/lib/lodash.js',
                        'static/lib/qwest.js',
                    ]
                }
            }
        },
        watch: {
            css: {
                files: 'stylus/*.styl',
                tasks: 'stylus'
            },
            libs: {
                files: ['static/libs/*.js'],
                tasks: ['uglify:libs']
            },
            coffee: {
                files: ['coffee/*.coffee', 'coffee/*/*.coffee'],
                tasks: ['coffee', 'uglify:tassel']
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-stylus');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-codo');

    grunt.registerTask('default', ['coffee', 'codo', 'stylus', 'uglify', 'watch']);
};
