require 'spec_helper'
require 'albacore/ilmerge'

describe IlMerge do

	context 'when setting #assemblies with empty list' do
	end

	context 'when setting #assemblies with 1 item' do
	end

	context 'when setting #assemblies with 2 items' do
	end

end

describe Albacore::IlMergeResolver, "Global Albacore#configure configuration" do

	describe "when Albacore::ConfigData#ilmerge_path hasn't been set" do

		context "and ilmerge.exe exists in Program Files" do
			before :each do
				set_file_exists '' => true, ' (x86)' => false
				@il_path = %q{C:\Program Files\Microsoft\ILMerge\ilmerge.exe}
				@me = Albacore::IlMergeResolver.new ''
			end

			subject { @me.resolve }
			it { should == @il_path }
		end

		context "and ilmerge only exists in Program Files (x86)" do
			before :all do
				set_file_exists '' => false, ' (x86)' => true
				@il_path = %q{C:\Program Files (x86)\Microsoft\ILMerge\ilmerge.exe}
				@me = Albacore::IlMergeResolver.new ''
			end

			subject { @me.resolve }
			it { should == @il_path }
		end
	end

	def set_file_exists(items)
		items.each_pair do |path,exists| 
			path = "C:\\Program Files#{path}\\Microsoft\\ILMerge\\ilmerge.exe"
			File.should_receive(:exists?).with(path).and_return(exists)
		end
	end

end

