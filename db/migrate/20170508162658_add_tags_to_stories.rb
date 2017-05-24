class AddTagsToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :tags, :string, array: true, default: []
    add_index  :stories, :tags, using: 'gin'  
  end
end
