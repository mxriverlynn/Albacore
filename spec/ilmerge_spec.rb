require 'spec_helper'
require 'albacore/ilmerge'

describe IlMerge do

	shared_examples_for "normal usages of IlMerge" do
		before :each do
			resolver = Albacore::IlMergeResolver.new 'ilmerge'
			@me = IlMerge.new resolver
			@me.output = 'output.dll'
		end
	end

	context 'when setting #assemblies with empty list' do
		it_should_behave_like "normal usages of IlMerge"

		it "raises an ArgumentError" do
			expect { @me.assemblies }.to raise_error(ArgumentError)
		end
	end

	context 'when setting #assemblies with 1 item' do
		it_should_behave_like "normal usages of IlMerge"

		it "raises an ArgumentError" do
			expect { @me.assemblies 'assy_1' }.to raise_error(ArgumentError)
		end
	end

	context 'when #assemblies is never called' do
		it_should_behave_like "normal usages of IlMerge"

		it "raises an ArgumentError" do
			expect { @me.build_parameters }.to raise_error(ArgumentError)
		end
	end

	context 'when setting #assemblies with 2 items' do
		it_should_behave_like "normal usages of IlMerge"

		it "has parameters that contains all assemblies listed" do
			@me.assemblies 'assy_1.dll', 'assy_2.dll'
			@me.build_parameters.should == %w{/out:output.dll assy_1.dll assy_2.dll}
		end
	end

end

describe Albacore::IlMergeResolver, "Global Albacore#configure configuration" do

	describe "when ilmerge_path hasn't been set" do

		context "and ilmerge.exe exists in Program Files" do
			before :each do
				set_file_exists '' => true, ' (x86)' => false
				@il_path = %q{C:\Program Files\Microsoft\ILMerge\ilmerge.exe}
				@me = Albacore::IlMergeResolver.new 
			end

			subject { @me.resolve }
			it { should == @il_path }
		end

		context "and ilmerge only exists in Program Files (x86)" do
			before :all do
				set_file_exists '' => false, ' (x86)' => true
				@il_path = %q{C:\Program Files (x86)\Microsoft\ILMerge\ilmerge.exe}
				@me = Albacore::IlMergeResolver.new 
			end

			subject { @me.resolve }
			it { should == @il_path }
		end
	end

	context "when ilmerge_path has been set" do
		before :each do
			@me = Albacore::IlMergeResolver.new 'path that exists'
		end

		subject { @me.resolve }
		it { should == 'path that exists' }
	end

	def set_file_exists(items)
		items.each_pair do |path,exists| 
			path = "C:\\Program Files#{path}\\Microsoft\\ILMerge\\ilmerge.exe"
			File.should_receive(:exists?).with(path).and_return(exists)
		end
	end

end

