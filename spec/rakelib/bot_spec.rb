require 'lib/config'
require 'lib/slack_interactor'
require 'lib/bot'
require 'rake'

RSpec.shared_context "rake task" do
  let(:rake) { Rake::Application.new }
  let(:task_path) { "rakelib/#{task_name.split(":").first}" }
  subject(:task) { Rake::Task[task_name] }
  subject(:run_task) do
    Rake::Task["bot:slack"].invoke
    Rake::Task["bot:slack"].reenable
  end

  before do
    Rake.application.rake_require(task_path)
  end
end

RSpec.describe 'bot:slack' do
  include_context 'rake task'
  let(:task_name) { 'bot:slack' }
  before do
    allow(Config).to receive(:new).and_return(config)
    allow(SlackInteractor).to receive(:new).and_return(slack_interactor)
    allow(Bot).to receive(:new).and_return(bot)
  end
  let(:config) { instance_double(Config) }
  let(:slack_interactor) { instance_double(SlackInteractor) }
  let(:bot) { instance_double(Bot, run: nil) }

  it 'creates a new Config' do
    expect(Config).to receive(:new)
    run_task
  end
  it 'creates a SlackInteractor with the Config' do
    expect(SlackInteractor).to receive(:new).with(config: config)
    run_task
  end
  it 'creates a new Bot with the Config and SlackInteractor' do
    expect(Bot).to receive(:new).with(config: config, interactor: slack_interactor)
    run_task
  end
  it 'runs the Bot' do
    expect(bot).to receive(:run)
    run_task
  end
end
