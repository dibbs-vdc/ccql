require 'rails_helper'

RSpec.describe CollectionSizeNotification do
  subject(:notification) { described_class.new(collection: collection, mailer: spy_mailer) }
  let(:collection)       { FactoryBot.build(:small_collection) }
  let(:spy_mailer)       { spy_mailer_class.new }

  let(:spy_mailer_class) do
    Class.new do
      attr_accessor :collection, :delivered

      def initialize
        self.delivered = false
      end

      def with(collection:, **)
        self.collection = collection
        self
      end

      def delivered?
        self.delivered
      end

      def method_missing(name, *_args, &_block)
        self.delivered = true if name.to_s.starts_with?('deliver')
        self
      end
    end
  end

  describe '#notify' do
    context 'with small collecion' do
      it 'should not deliver mail' do
        expect { notification.notify }
          .not_to change { spy_mailer.delivered? }
          .from false
      end
    end

    context 'with a large collecion' do
      let(:collection) { FactoryBot.build(:large_collection) }

      it 'should deliver mail' do
        expect { notification.notify }
          .to change { spy_mailer.delivered? }
          .from(false)
          .to(true)
      end
    end
  end
end
