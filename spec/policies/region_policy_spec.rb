require 'rails_helper'

RSpec.describe RegionPolicy do
  let(:region) { build(:region) }

  subject { described_class.new(volunteer, region) }

  context 'for a super admin' do
    let(:volunteer) { build(:volunteer, admin: true) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'for a region admin' do
    let(:volunteer) { create(:volunteer) }
    let!(:assignment) { create(:assignment, volunteer: volunteer, admin: true) }

    it { is_expected.to forbid_action(:index) }

    context 'for another region' do
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'for their region' do
      before do
        assignment.region = region
        assignment.save
      end

      it { is_expected.to forbid_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'for an assigned volunteer' do
    let(:volunteer) { create(:volunteer) }
    let!(:assignment) { create(:assignment, volunteer: volunteer) }

    it { is_expected.to forbid_action(:index) }

    context 'for another region' do
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'for their region' do
      before do
        assignment.region = region
        assignment.save
      end

      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end