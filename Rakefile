require 'sass'
require 'coffee_script'
require 'guard/notifier'

Guard::Notifier::turn_on

def build_pages
    branch = 'gh-pages'
    puts "Updating '#{branch}' branch"

    require 'grit'
    require 'digest'

    repo = Grit::Repo.new '.'
    index = Grit::Index.new repo
    index.read_tree 'HEAD'

    pages = repo.get_head branch
    abort "No '#{branch}' branch found" unless pages

    File.open 'index.html' do |fh|
        index.add 'index.html', fh.read
    end

    %w< assets/quiz.js assets/map.css assets/style.css >.each do |name|
        File.open name do |fh|
            data = fh.read
            hash = Digest::SHA1.new
            hash << data
            index.add "#{Digest.hexencode hash.digest}/#{name}", data
        end
    end

    index.commit "Rebuild pages", [pages.commit.id, repo.head.commit.id], nil, pages.commit.tree.id, branch
end

def coffee task
    src = task.prerequisites[0]
    dst = task.name
    puts "#{src} => #{dst}"
    compiled = CoffeeScript.compile File.read(src)
    File.open dst, 'w' do |f|
        f.write compiled
    end
rescue
    Guard::Notifier.notify $!.to_s, :image => :failed, :title => src
    abort $!.to_s
end

def sass task
    src = task.prerequisites[0]
    dst = task.name
    puts "#{src} => #{dst}"
    Sass.compile_file src, dst
rescue
    Guard::Notifier.notify $!.to_s, :image => :failed, :title => src
end

class ERuby
    attr_reader :task, :data

    def initialize task, data={}
        @task = task
        @data = data
    end

    def build
        require 'erb'

        src = task.prerequisites[0]
        dst = task.name
        puts "#{src} => #{dst}"

        data.each do |k,v|
            instance_variable_set "@#{k}", v
        end

        template = File.open(src) { |fh| fh.read }
        b = binding
        out = ERB.new( template ).result b

        File.open dst, 'w' do |fh|
            fh.write out
        end
    end

    def self.build *args
        self.new(*args).build
    end
end

file 'assets/quiz.js' => 'src/quiz.coffee' do |t|
    coffee t
end
task :assets => 'assets/quiz.js'

file 'assets/map.css' => 'src/map.scss' do |t|
    sass t
end
task :assets => 'assets/map.css'

file 'assets/style.css' => 'src/style.scss' do |t|
    sass t
end
task :assets => 'assets/style.css'

file 'index.html' => [ 'src/index.erb', :assets ] do |t|
    ERuby.build t
end

file 'dev.html' => [ 'src/index.erb', :assets ] do |t|
    ERuby.build t, development: true
end

task :guarded => 'dev.html'

task :pages => 'index.html' do
    build_pages
end
