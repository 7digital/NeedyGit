include Rake::DSL

class Dependency

	def initialize(author, git='git')
		@git = git
		@author = author
	end

	def update(folder)
		sh "#{@git} pull"
		sh "#{@git} add #{folder}"
		
		message = `#{@git} status #{folder}`
		puts message
		return if message.include?('nothing to commit')
		
		sh "#{@git} commit #{folder} --author=\"#{@author}\" -m \"Dependency Auto Commit. Build number #{build_number}.\""
		sh "#{@git} push"			
	end
	
	def update_submodule(folder)
		sh "#{@git} submodule update --init"
		sh "#{@git} submodule update"
		root_dir = Dir.pwd
		Dir.chdir(folder)

		sh "#{@git} pull origin master"
		Dir.chdir(root_dir)	
	end
	
	private
	
	def build_number
		return ENV["BUILD_NUMBER"].nil? ? 'N/A' : ENV["BUILD_NUMBER"]
	end
	
end

