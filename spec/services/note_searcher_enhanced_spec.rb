require File.expand_path('app/services/note_searcher')

class Note
  include Enumerable

  attr_accessor :title, :content, :starred, :read

  QUERY = 'note query'

  def initialize(*args)
    if args[0].is_a?(Array)
      @data = args[0]
    else
      @data = []
    end

    if args[0].is_a?(Hash)
      h = args[0]
      @title = h[:title]
      @content = h[:content]
      @starred = h[:starred] | false
      @read = h[:read] | false
    end
  end

  def <<(item)
    @data << item

    self
  end

  def each(&block)
    @data.each do |item|
      if block_given?
        block.call(item)
      else
        yield(item)
      end
    end
  end

  class << self
    def unscoped
      unscoped = Note.new

      ['Note content', QUERY].each do |query|
        [true, false].each do |starring|
          [true, false].each do |reading|
            unscoped << Note.new(content: query, starred: starring, read: reading)
          end
        end
      end

      unscoped
    end

    alias_method :all, :unscoped

    def starred_notes
      Note.new(unscoped.select(&:starred))
    end

    def unstarred_notes
      Note.new(unscoped.reject(&:starred))
    end

    def read_notes
      Note.new(unscoped.select(&:read))
    end

    def unread_notes
      Note.new(unscoped.reject(&:read))
    end

    def search(query)
      return unscoped if query.nil? or query == '*'

      Note.new(unscoped.select{ |note| note.content.include?(query) })
    end
  end

  def starred_notes
    Note.new(self.select(&:starred))
  end

  def unstarred_notes
    Note.new(self.reject(&:starred))
  end

  def read_notes
    Note.new(self.select(&:starred))
  end

  def unread_notes
    Note.new(self.reject(&:read))
  end

  def search(query)
    return self if query.nil? or query == '*'

    Note.new(self.select{ |note| note.content.include?(query) })
  end
end

describe NoteSearcher do
  let(:searcher) { NoteSearcher.new }

  describe '#search' do
    describe 'when filters are provided' do
      let(:params) { {} }

      describe 'query filtering' do
        context 'when query is provided' do
          let(:params)  { { query: Note::QUERY } }

          it 'returns notes filtered by query' do
            expect(searcher.search(params)).to match_array Note.search(Note::QUERY)
          end
        end

        context 'when query is not provided' do
          it 'returns all notes' do
            expect(searcher.search(params)).to match_array Note.all
          end
        end
      end

      describe 'starred notes filtering' do
        context "when 'starred' flag is provided" do
          context "when 'starred' flag is '1'" do
            let(:params) { { starred: '1' } }

            it 'returns starred notes' do
              expect(searcher.search(params)).to match_array Note.starred_notes
            end
          end

          context "when 'starred' flag is '0'" do
            let(:params) { { starred: '0' } }

            it 'returns unstarred notes' do
              expect(searcher.search(params)).to match_array Note.unstarred_notes
            end
          end
        end

        context "when 'starred' flag is not provided" do
          it 'returns all notes' do
            expect(searcher.search(params)).to match_array Note.all
          end
        end
      end

      describe 'read notes filtering' do
        context "when 'read' flag is provided" do
          context "when 'read' flag is '1'" do
            let(:params) { { read: '1' } }

            it 'returns read notes' do
              expect(searcher.search(params)).to match_array Note.read_notes
            end
          end

          context "when 'read' flag is '0'" do
            let(:params) { { read: '0' } }

            it 'returns unread notes' do
              expect(searcher.search(params)).to match_array Note.unread_notes
            end
          end
        end

        context "when 'read' flag is not provided" do
          it 'returns all notes' do
            expect(searcher.search(params)).to match_array Note.all
          end
        end
      end
    end

    context 'when filters are not provided' do
      it 'returns all notes' do
        expect(searcher.search).to match_array Note.all
      end
    end
  end
end
