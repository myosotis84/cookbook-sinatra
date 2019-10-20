require 'nokogiri'
require 'open-uri'

class ScrapeLetscookfrenchService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{@ingredient}"
    html_doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    results = []
    html_doc.search(".m_contenu_resultat").first(5).each do |recipe|
      recipe_name = recipe.search(".m_titre_resultat a").text.strip
      description = recipe.search(".m_texte_resultat").text.strip
      prep_time = recipe.search(".m_detail_time :first-child").text.strip
      difficulty = recipe.search(".m_detail_recette").text.strip.split("-")[2].strip
      results << [recipe_name, description, prep_time, difficulty]
    end
    results
  end
end
