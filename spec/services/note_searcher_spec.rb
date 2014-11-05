require 'rails_helper'

describe NoteSearcher do
  let(:searcher) { NoteSearcher.new }

  describe '#search' do
    describe 'when filters are provided' do
      let(:params) { {} }

      describe 'query filtering' do
        let(:query)           { 'not query' }
        let!(:notes)          { create_list(:note, 5) }
        let!(:filtered_notes) { create_list(:note, 5, content: query) }

        context 'when query is provided' do
          let(:params) { { query: query } }

          it 'returns notes filtered by query' do
            expect(searcher.search(params)).to match_array filtered_notes
          end
        end

        context 'when query is not provided' do
          it 'returns all notes' do
            all_notes = [notes, filtered_notes].flatten

            expect(searcher.search(params)).to match_array all_notes
          end
        end
      end

      describe 'starred notes filtering' do
        let!(:starred_notes)   { create_list(:starred_note, 5) }
        let!(:unstarred_notes) { create_list(:unstarred_note, 5) }

        context "when 'starred' flag is provided" do
          context "when 'starred' flag is '1'" do
            let(:params) { { starred: '1' } }

            it 'returns starred notes' do
              expect(searcher.search(params)).to match_array starred_notes
            end
          end

          context "when 'starred' flag is '0'" do
            let(:params) { { starred: '0' } }

            it 'returns unstarred notes' do
              expect(searcher.search(params)).to match_array unstarred_notes
            end
          end
        end

        context "when 'starred' flag is not provided" do
          it 'returns all notes' do
            all_notes = [starred_notes, unstarred_notes].flatten

            expect(searcher.search(params)).to match_array all_notes
          end
        end
      end

      describe 'read notes filtering' do
        let!(:read_notes)   { create_list(:read_note, 5) }
        let!(:unread_notes) { create_list(:unread_note, 5) }

        context "when 'read' flag is provided" do
          context "when 'read' flag is '1'" do
            let(:params) { { read: '1' } }

            it 'returns read notes' do
              expect(searcher.search(params)).to match_array read_notes
            end
          end

          context "when 'read' flag is '0'" do
            let(:params) { { read: '0' } }

            it 'returns unread notes' do
              expect(searcher.search(params)).to match_array unread_notes
            end
          end
        end

        context "when 'read' flag is not provided" do
          it 'returns all notes' do
            all_notes = [read_notes, unread_notes].flatten

            expect(searcher.search(params)).to match_array all_notes
          end
        end
      end
    end

    context 'when filters are not provided' do
      let!(:notes)           { create_list(:note, 5) }
      let!(:starred_notes)   { create_list(:starred_note, 5) }
      let!(:unstarred_notes) { create_list(:starred_note, 5) }
      let!(:read_notes)      { create_list(:read_note, 5) }
      let!(:unread_notes)    { create_list(:unread_note, 5) }

      it 'returns all notes' do
        all_notes = [notes, starred_notes, unstarred_notes, read_notes, unread_notes].flatten

        expect(searcher.search).to match_array all_notes
      end
    end
  end
end
