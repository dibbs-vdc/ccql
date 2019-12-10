# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'

RSpec.describe Hyrax::Actors::Vdc::ResourceActor do
  subject(:actor)  { described_class.new(next_actor) } 
  let(:env)        { Hyrax::Actors::Environment.new(model, ability, attributes) }
  let(:next_actor) { Hyrax::Actors::Terminator.new() }
  let(:user)       { FactoryBot.create(:user) }
  let(:model)      { FactoryBot.build(:vdc_resource) }

  let(:ability)    { Ability.new(user) }
  let(:attributes) { Hash.new() }

  describe '#create' do
    context 'regardless of visibility' do
      before do
        actor.create(env)
      end

      it 'sets creation date to now' do
        expect(model.creation_date).to eq([Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')])
      end
    end

    context 'with PUBLIC visibility' do
      let(:attributes) { { visibility: described_class::PUBLIC } }

      it 'enqueues GenerateDoiJob' do
        ActiveJob::Base.queue_adapter = :test
        expect { actor.create(env) }
          .to have_enqueued_job(GenerateDoiJob)
      end
    end

    context 'with VDC visibility' do
      let(:attributes) { { visibility: described_class::VDC } }

      it 'enqueues GenerateDoiJob' do
        ActiveJob::Base.queue_adapter = :test
        expect { actor.create(env) }
          .to have_enqueued_job(GenerateDoiJob)
      end
    end

    context 'with PRIVATE visibility' do
      let(:attributes) { { visibility: described_class::PRIVATE } }

      it 'does not enqueue GenerateDoiJob' do
        ActiveJob::Base.queue_adapter = :test
        expect { actor.create(env) }
          .to_not have_enqueued_job(GenerateDoiJob)
      end
    end
  end

  describe '#update' do
    context 'when switching visibility' do
      context 'so original visibility private' do
        before do
          actor.create(env)
          model.creation_date = ['2018-09-09']
          model.visibility = described_class::PRIVATE
          model.save!
        end

        context 'switches to public' do
          let(:attributes) { { visibility: described_class::PUBLIC } }

          it 'updates creation date to now' do
            expect { actor.update(env) }.to change{ 
              model.creation_date.to_a 
            }.from(['2018-09-09']).to([Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')])
          end

          it 'enqueues GenerateDoiJob' do
            ActiveJob::Base.queue_adapter = :test
            expect { actor.create(env) }
              .to have_enqueued_job(GenerateDoiJob)
          end
        end

        context 'switches to VDC' do
          let(:attributes) { { visibility: described_class::VDC } }
     
          it 'updates creation date to now' do
            expect { actor.update(env) }.to change{
              model.creation_date.to_a 
            }.from(['2018-09-09']).to([Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')])
          end

          it 'enqueues GenerateDoiJob' do
            ActiveJob::Base.queue_adapter = :test
            expect { actor.create(env) }
              .to have_enqueued_job(GenerateDoiJob)
          end
        end
      end

      context 'so original visibility public' do
        before do
          actor.create(env)
          model.visibility = described_class::PUBLIC
          model.save!
        end

        context 'switches to private' do
          let(:attributes) { { visibility: described_class::PRIVATE } }

          it 'does not enqueue GenerateDoiJob' do
            ActiveJob::Base.queue_adapter = :test
            expect { actor.create(env) }
              .to_not have_enqueued_job(GenerateDoiJob)
          end
        end
      end
    end

    context 'when not swiching visibiity' do
      context 'so original public visibility ' do
        let(:attributes) { { visibility: described_class::PUBLIC } }

        before do
          actor.create(env)
          model.creation_date = ['2018-09-09']
          model.save!
        end

        context 'does not change' do
          let(:attributes) { { visibility: described_class::PUBLIC } }

          it 'will not change creation date' do
            expect { actor.update(env) }.not_to change{ model.creation_date.to_a }
          end
        end
      end

      context 'so original VDC visibility' do
        let(:attributes) { { visibility: described_class::VDC } }

        before do
          actor.create(env)
          model.creation_date = ['2018-09-09']
          model.save!
        end

        context 'does not change' do
          let(:attributes) { { visibility: described_class::VDC } }

          it 'will not change creation date' do
            expect { actor.update(env) }.not_to change{ model.creation_date.to_a }
          end
        end
      end
    end
  end
end
