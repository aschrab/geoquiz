require 'sass'
require 'coffee_script'
require 'guard/notifier'

Guard::Notifier::turn_on

def build_pages
    branch = 'gh-pages'
    puts "Updating '#{branch}' branch"

    require 'grit'

    repo = Grit::Repo.new '.'
    index = Grit::Index.new repo
    index.read_tree 'HEAD'

    pages = repo.get_head branch
    abort "No '#{branch}' branch found" unless pages

    %w< index.html assets/quiz.js assets/map.css assets/style.css >.each do |name|
        File.open name do |fh|
            index.add name, fh.read
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
else
    Guard::Notifier.notify "Recompiled", :title => src
end

def sass task
    src = task.prerequisites[0]
    dst = task.name
    puts "#{src} => #{dst}"
    Sass.compile_file src, dst
rescue
    Guard::Notifier.notify $!.to_s, :image => :failed, :title => src
else
    Guard::Notifier.notify "Recompiled", :title => src
end

file 'assets/quiz.js' => 'src/quiz.coffee' do |t|
    coffee t
end
task :pages => 'assets/quiz.js'

file 'assets/map.css' => 'src/map.scss' do |t|
    sass t
end
task :pages => 'assets/map.css'

file 'assets/style.css' => 'src/style.scss' do |t|
    sass t
end
task :pages => 'assets/style.css'

task :pages do
    build_pages
end
