class NoteSearcher
  def search(params = {})
    relation = Note.unscoped
    relation = relation.starred_notes if params[:starred] == '1'
    relation = relation.unstarred_notes if params[:starred] == '0'
    relation = relation.read_notes if params[:read] == '1'
    relation = relation.unread_notes if params[:read] == '0'
    relation.search(params[:query])
  end
end
