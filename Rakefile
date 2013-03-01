task :pages => :guarded do
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

task :guarded do
    require 'guard'
    Guard.setup :guardfile => 'Guardfile'
    Guard.run_all
end
