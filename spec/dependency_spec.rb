require 'support/spec_helper'
require 'dependency'

shared_examples_for 'dependency' do	
	before(:each) do
		@dependency = Dependency.new('my-author')				
	end
end

describe Dependency do
	include_context 'dependency'

	context 'Given a dependency is being updated' do
		before(:each) do
			@dependency.expects('sh').with('git pull')
			@dependency.expects('sh').with('git add myfolder')			
		end	
		
		it 'does not push when there is nothing to commit' do
			@dependency.expects('system').with('git status myfolder').returns('nothing to commit')
			@dependency.expects('sh').with('git push').never
			@dependency.update('myfolder')
		end		
		
		it 'pushes with there are files to commit' do
			@dependency.expects('system').with('git status myfolder').returns('lots of stuff to commit')
			@dependency.expects('sh').with('git commit myfolder --author="my-author" -m "Dependency Auto Commit. Build number N/A."')
			@dependency.expects('sh').with('git push')
			@dependency.update('myfolder')
		end			
	end

	context 'Given a submodule is updated' do
		it 'updates the submodule' do
			@dependency.expects('sh').with('git submodule update --init')
			@dependency.expects('sh').with('git submodule update')					
			@dependency.expects('sh').with('git pull origin master')
			Dir.expects('chdir').with('myfolder')
			Dir.expects('chdir').with(Dir.pwd)

			@dependency.update_submodule('myfolder')			
		end
	end
	
end