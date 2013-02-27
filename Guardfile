# More info at https://github.com/guard/guard#readme

guard 'coffeescript',
    input:          'src',
    output:         'assets',
    all_on_start:   true

guard 'sass',
    input:          'src',
    output:         'assets',
    all_on_start:   true,
    style:          :expanded

guard :shell do
    files = %r{
        ^(
            assets/.*\.(js|css)
            |
            src/index\.erb
        )$
    }x

    watch files do |m|
        `erb src/index.erb > index.html`
    end
end
