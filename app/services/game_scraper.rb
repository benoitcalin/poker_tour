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
    has_bounty = html_doc.search('.tournament-type')[1].search('.tournament-col').count === 3
    has_reentry = html_doc.search('.tournament-type')[3].search('.tournament-col').count === 2
    if has_bounty && has_reentry
      create_hash_reentry_bounty(html_doc)
    elsif has_bounty
      create_hash_bounty(html_doc)
    elsif has_reentry
      create_hash_reentry(html_doc)
    else
      create_hash(html_doc)
    end
  end

  def create_hash_reentry_bounty(html_doc)
    {
      winamax_id: @winamax_id,
      name: html_doc.search('.page-title').first.text.strip,
      buyin: strip_to_float(html_doc.search('.tournament-col').first),
      bounty: strip_to_float(html_doc.search('.tournament-col')[1]),
      rake: strip_to_float(html_doc.search('.tournament-col')[2]),
      start_time: Time.parse(strip_split(html_doc.search('.tournament-col')[3], ' : ')),
      end_time: Time.parse(strip_split(html_doc.search('.tournament-col')[4], ' : ')),
      total_registrations: strip_split(html_doc.search('.tournament-col')[5], ' : ').to_f,
      total_reentries: strip_split(html_doc.search('.tournament-col')[6], ' : ').to_f
    }
  end

  def create_hash_reentry(html_doc)
    {
      winamax_id: @winamax_id,
      name: html_doc.search('.page-title').first.text.strip,
      buyin: strip_to_float(html_doc.search('.tournament-col').first),
      bounty: 0.00,
      rake: strip_to_float(html_doc.search('.tournament-col')[1]),
      start_time: Time.parse(strip_split(html_doc.search('.tournament-col')[2], ' : ')),
      end_time: Time.parse(strip_split(html_doc.search('.tournament-col')[3], ' : ')),
      total_registrations: strip_split(html_doc.search('.tournament-col')[4], ' : ').to_f,
      total_reentries: strip_split(html_doc.search('.tournament-col')[5], ' : ').to_f
    }
  end

  def create_hash_bounty(html_doc)
    {
      winamax_id: @winamax_id,
      name: html_doc.search('.page-title').first.text.strip,
      buyin: strip_to_float(html_doc.search('.tournament-col').first),
      bounty: strip_to_float(html_doc.search('.tournament-col')[1]),
      rake: strip_to_float(html_doc.search('.tournament-col')[2]),
      start_time: Time.parse(strip_split(html_doc.search('.tournament-col')[3], ' : ')),
      end_time: Time.parse(strip_split(html_doc.search('.tournament-col')[4], ' : ')),
      total_registrations: strip_split(html_doc.search('.tournament-col')[5], ' : ').to_f,
      total_reentries: 0.00
    }
  end

  def create_hash(html_doc)
    {
      winamax_id: @winamax_id,
      name: html_doc.search('.page-title').first.text.strip,
      buyin: strip_to_float(html_doc.search('.tournament-col').first),
      bounty: 0.00,
      rake: strip_to_float(html_doc.search('.tournament-col')[1]),
      start_time: Time.parse(strip_split(html_doc.search('.tournament-col')[2], ' : ')),
      end_time: Time.parse(strip_split(html_doc.search('.tournament-col')[3], ' : ')),
      total_registrations: strip_split(html_doc.search('.tournament-col')[4], ' : ').to_f,
      total_reentries: 0.00
    }
  end

  def create_result_hash(html_doc)
    results = []
    html_doc.search('tr').each_with_index do |row, id|
      next if id == 0 && row.children.first.name == "text"

      has_bounty = html_doc.search('.tournament-type')[1].search('.tournament-col').count === 3
      has_reentry = html_doc.search('.tournament-type')[3].search('.tournament-col').count === 2

      if has_bounty && has_reentry
        headers = ["position", "player_name", "earnings", "bounties", "reentries"]
      elsif has_bounty
        headers = ["position", "player_name", "earnings", "bounties"]
      elsif has_reentry
        headers = ["position", "player_name", "earnings", "reentries"]
      else
        headers = ["position", "player_name", "earnings"]
      end

      hash = {}
      row.search('td').each_with_index do |elt, index|
        case index
        when 0 then element = strip_to_string(elt).to_f
        when 1 then element = strip_to_string(elt)
        when 2 then element = strip_to_float(elt)
        when 3 then element = strip_to_string(elt).include?("€") ? strip_to_float(elt) : strip_to_string(elt).to_f
        when 4 then element = strip_to_string(elt).include?("€") ? strip_to_float(elt) : strip_to_string(elt).to_f
        end
        hash[headers[index]] = element
      end
      results << hash
    end
    results
  end
end
