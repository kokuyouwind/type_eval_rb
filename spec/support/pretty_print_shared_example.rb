# frozen_string_literal: true

RSpec.shared_examples 'output expected pretty_print' do |expected|
  let(:buffer) { +'' }
  let(:q) { PP.new(buffer) }

  it 'pretty prints the node' do
    node.pretty_print(q)
    q.flush
    expect(buffer).to eq(expected)
  end
end
