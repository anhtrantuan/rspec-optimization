require 'model_helper'

describe Note do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }

  describe '.starred_notes' do
    let!(:starred_notes)   { create_list(:starred_note, 5) }
    let!(:unstarred_notes) { create_list(:unstarred_note, 5) }

    it 'returns starred notes' do
      expect(Note.starred_notes).to match_array starred_notes
    end
  end

  describe '.unstarred_notes' do
    let!(:starred_notes)   { create_list(:starred_note, 5) }
    let!(:unstarred_notes) { create_list(:unstarred_note, 5) }

    it 'returns unstarred notes' do
      expect(Note.unstarred_notes).to match_array unstarred_notes
    end
  end

  describe '.read_notes' do
    let!(:read_notes)   { create_list(:read_note, 5) }
    let!(:unread_notes) { create_list(:unread_note, 5) }

    it 'returns read notes' do
      expect(Note.read_notes).to match_array read_notes
    end
  end

  describe '.unread_notes' do
    let!(:read_notes)   { create_list(:read_note, 5) }
    let!(:unread_notes) { create_list(:unread_note, 5) }

    it 'returns unread notes' do
      expect(Note.unread_notes).to match_array unread_notes
    end
  end

  describe '.search' do
    context 'when query is provided' do
      let(:query)           { 'note query' }
      let!(:notes)          { create_list(:note, 5) }
      let!(:filtered_notes) { create_list(:note, 5, content: query) }

      it 'returns filtered notes' do
        expect(Note.search(query)).to match_array filtered_notes
      end
    end

    context 'when query is note provided' do
      let!(:notes) { create_list(:note, 10) }

      it 'returns all notes' do
        expect(Note.search).to match_array Note.all
      end
    end
  end
end
