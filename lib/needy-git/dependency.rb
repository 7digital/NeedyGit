include Rake::DSL

class Dependency

	def initialize(author, git='git')
		@git = git
		@author = author
	end

	def update(folder)
		sh "#{@git} pull"
		sh "#{@git} add #{folder}"
		
		commit_and_push(folder)	unless nothing_to_commit(folder)
	end
	
	def update_submodule(folder)
		sh "#{@git} submodule update --init"
		sh "#{@git} submodule update"
		root_dir = Dir.pwd
		
		Dir.chdir(folder)
		sh "#{@git} pull origin master"		
		Dir.chdir(root_dir)	
		
		commit_and_push(folder) unless nothing_to_commit(folder)
	end
	
	private
	
	def nothing_to_commit(folder)
		message = `#{@git} status #{folder}`
		puts message
		return message.include?('nothing to commit')		
	end
	
	def commit_and_push(folder)
		sh "#{@git} commit #{folder} --author=\"#{@author}\" -m \"Dependency Auto Commit. Build number #{build_number}.\""
		sh "#{@git} push"		
	end
	
	def build_number
		return ENV["BUILD_NUMBER"].nil? ? 'N/A' : ENV["BUILD_NUMBER"]
	end
	
end

