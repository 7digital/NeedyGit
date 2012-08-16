root_dir = File.expand_path(File.dirname(__FILE__))
$: << root_dir
$: << File.join(root_dir, 'needy-git')
$: << File.join(root_dir, 'needy-git', 'support')

Dir.glob(File.join(root_dir, '**/*.rb')).each {|file| require file }
