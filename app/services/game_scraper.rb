require 'open-uri'
require 'nokogiri'

class GameScraper
  def initialize(winamax_id)
    @winamax_id = winamax_id
    @base_url = 'https://www.winamax.fr/poker/tournament.php?ID='
    @url = @base_url + @winamax_id
  end

  def scrape
    html_file = open(@url).read
    html_doc = Nokogiri::HTML(html_file)

    {
      game: create_game_hash(html_doc),
      results: create_result_hash(html_doc)
    }
  end

  private

  def strip_to_float(element)
    element.text.strip.scan(/\d+(?:\,\d{1,2})/).first.gsub(',', '.').to_f
  end

  def strip_split(element, split_characters)
    element.text.strip.split(split_characters).last
  end

  def strip_to_string(element)
    element.text.strip
  end

  def create_game_hash(html_doc)
    reentries = html_doc.search('.tournament-col')[5] ? strip_split(html_doc.search('.tournament-col')[5], ' : ').to_f : 0.0
    {
      winamax_id: @winamax_id,
      name: html_doc.search('.page-title').first.text.strip,
      buyin: strip_to_float(html_doc.search('.tournament-col').first),
      rake: strip_to_float(html_doc.search('.tournament-col')[1]),
      start_time: Time.parse(strip_split(html_doc.search('.tournament-col')[2], ' : ')),
      end_time: Time.parse(strip_split(html_doc.search('.tournament-col')[3], ' : ')),
      total_registrations: strip_split(html_doc.search('.tournament-col')[4], ' : ').to_f,
      total_reentries: reentries
    }
  end

  def create_result_hash(html_doc)
    results = []
    html_doc.search('tr').each_with_index do |row, id|
      next if id == 0
      headers = ["position", "player_name", "earnings", "reentries"]
      hash = {}
      row.search('td').each_with_index do |elt, index|
        case index
        when 0 then element = strip_to_string(elt).to_f
        when 1 then element = strip_to_string(elt)
        when 2 then element = strip_to_float(elt)
        when 3 then element = elt ? strip_to_string(elt).to_f : 0.00
        end
        hash[headers[index]] = element
      end
      results << hash
    end
    results
  end
end
