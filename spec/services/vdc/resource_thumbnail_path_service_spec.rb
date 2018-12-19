require 'rails_helper'

RSpec.describe Vdc::ResourceThumbnailPathService do
  describe '.call' do
    let(:resource) { FactoryBot.create(:vdc_resource) }
    let(:fileset)  { FactoryBot.create(:file_set, content: StringIO.new('something')) }
    let(:fake_image_resolver) do
      resolver = Class.new do
        def image_path_for(*)
          'blah.png'
        end
      end
      resolver.new
    end

    context 'when work has no filesets' do
      it 'returns the default work thumbnail ' do
        expect(described_class.call(resource)).to match /default\-.*\.png$/
      end
    end

    context 'when passed an image_resolver' do
      it 'returns the path from the resolver' do
        resource.thumbnail_id = fileset.id

        expect(described_class.call(resource, image_resolver: fake_image_resolver)).to eq('blah.png')
      end
    end
  end
end

RSpec.describe Vdc::ResourceThumbnailPathService::ThumbnailImageResolver do
  let(:fileset) { instance_double(FileSet, mime_type: mime_type) }
  context 'with a fileset of unknown type' do
    let(:mime_type) { 'DEFINITELY_NOT-A REAL_MIME type' }
    it 'returns nil' do
      expect(subject.image_path_for(fileset)).to be_nil
    end
  end

  context 'with a .csv fileset' do
    let(:mime_type) { 'text/csv' }
    it 'gives the default .csv thumbnail' do
      expect(subject.image_path_for(fileset)).to match /csv\-.*\.svg$/
    end
  end

  context 'with a excel fileset' do
    let(:mime_type) { 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
    it 'gives the default excel thumbnail' do
      expect(subject.image_path_for(fileset)).to match /excel\-.*\.svg$/
    end
  end

  context 'with an image (png) fileset' do
    let(:mime_type) { 'image/png' }
    it 'gives the default image thumbnail' do
      expect(subject.image_path_for(fileset)).to match /image\-.*\.svg$/
    end
  end

  context 'with an image (jpeg) fileset' do
    let(:mime_type) { 'image/jpeg' }
    it 'gives the default image thumbnail' do
      expect(subject.image_path_for(fileset)).to match /image\-.*\.svg$/
    end
  end

  context 'with a json fileset' do
    let(:mime_type) { 'application/json' }
    it 'gives the default json thumbnail' do
      expect(subject.image_path_for(fileset)).to match /json\-.*\.svg$/
    end
  end

  context 'with a .pdf fileset' do
    let(:mime_type) { 'application/pdf' }
    it 'gives the default .pdf thumbnail' do
      expect(subject.image_path_for(fileset)).to match /pdf\-.*\.svg$/
    end
  end

  context 'with a .sav fileset' do
    let(:mime_type) { 'application/octet-stream' }
    it 'gives the default .sav thumbnail' do
      expect(subject.image_path_for(fileset)).to match /sav\-.*\.svg$/
    end
  end

  context 'with a generic text fileset' do
    let(:mime_type) { 'text/plain' }
    it 'gives the default generic text thumbnail' do
      expect(subject.image_path_for(fileset)).to match /text\-.*\.svg$/
    end
  end

  context 'with a mp4 fileset' do
    let(:mime_type) { 'video/mp4' }
    it 'gives the default video thumbnail' do
      expect(subject.image_path_for(fileset)).to match /video\-.*\.svg$/
    end
  end

  context 'with a quicktime video fileset' do
    let(:mime_type) { 'video/quicktime' }
    it 'gives the default video thumbnail' do
      expect(subject.image_path_for(fileset)).to match /video\-.*\.svg$/
    end
  end

  context 'with a .zip fileset' do
    let(:mime_type) { 'application/zip' }
    it 'gives the default .zip thumbnail' do
      expect(subject.image_path_for(fileset)).to match /zip\-.*\.svg$/
    end
  end
end
