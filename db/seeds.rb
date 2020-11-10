require 'open-uri'
require 'nokogiri'

game_ids = ['337357698', '337731880', '344624175', '346612586', '348273498', '350145852', '352493558', '354523393', '356601454', '357057091', '360574181']

Tournament.destroy_all
User.destroy_all
Game.destroy_all
Player.destroy_all
Session.destroy_all
Participation.destroy_all
Result.destroy_all


# CPT - Allis
user = User.create!(email: 'benoit.calin@gmail.com', password: ENV["PASSWORD_ADMIN"], username: "La Chatte", winamax_name: "Chaton96")
puts "Admin created"

tournament = Tournament.new(name: "Confinement Poker Tour - Allis")
tournament.user = user
tournament.save!
puts "#{tournament.name} created"

game_ids.each do |game_id|
  scrapings = GameScraper.new(game_id).scrape

  game = Game.find_or_initialize_by(winamax_id: scrapings[:game][:winamax_id])
  if game.id.nil?
    game.attributes = scrapings[:game]
    game.save!

    scrapings[:results].each do |result|
      player = Player.find_or_initialize_by(name: result["player_name"])
      player.name = result["player_name"]
      player.save!
      puts "Player #{player.name} created"

      new_result = Result.new(result.except("player_name"))
      if result['position'] == 1
        other_bounties = game.total_registrations * game.bounty - new_result.bounties
        new_result.kills = game.bounty > 0 ? (((new_result.bounties - other_bounties) / game.bounty) - 1.0) : 0.00
      else
        new_result.kills = game.bounty > 0 ? new_result.bounties / (game.bounty / 2.0) : 0.00
      end
      new_result.player = player
      new_result.game = game
      new_result.save!
      puts "Result for player #{player.name} created"
    end
  end

  puts "Game #{game.name} created"

  session = Session.new
  session.game = game
  session.tournament = tournament
  session.save!
  puts "Session for game #{game.name} in tournament #{tournament.name} created"

  # Update Tournament Result Data
  scrapings[:results].each do |result|
    player = Player.find_by_name(result["player_name"])
    tournament_result = TournamentResult.find_or_initialize_by(player: player, tournament: tournament)
    if tournament_result.id.nil?
      tournament_result.player = player
      tournament_result.tournament = tournament
      tournament_result.save!
    end
    tournament_result.update!(tournament.updated_player_results(player))
  end
end

# Ligue 1 Hubert Bite
hb_tournament = Tournament.new(name: "Confinement Poker Tour - Ligue 1 Hubert Bite")
hb_tournament.user = user
hb_tournament.save!
puts "#{hb_tournament.name} created"

hb_game_ids = ['362159900', '362089613', '359272358', '359216685', '356326439', '356279110']

hb_game_ids.each do |game_id|
  scrapings = GameScraper.new(game_id).scrape

  game = Game.find_or_initialize_by(winamax_id: scrapings[:game][:winamax_id])
  if game.id.nil?
    game.attributes = scrapings[:game]
    game.save!

    scrapings[:results].each do |result|
      player = Player.find_or_initialize_by(name: result["player_name"])
      player.name = result["player_name"]
      player.save!
      puts "Player #{player.name} created"

      new_result = Result.new(result.except("player_name"))
      new_result.player = player
      new_result.game = game
      new_result.save!
      puts "Result for player #{player.name} created"
    end
  end

  puts "Game #{game.name} created"

  session = Session.new
  session.game = game
  session.tournament = hb_tournament
  session.save!
  puts "Session for game #{game.name} in tournament #{hb_tournament.name} created"

  # Update Tournament Result Data
  scrapings[:results].each do |result|
    player = Player.find_by_name(result["player_name"])
    tournament_result = TournamentResult.find_or_initialize_by(player: player, tournament: hb_tournament)
    if tournament_result.id.nil?
      tournament_result.player = player
      tournament_result.tournament = hb_tournament
      tournament_result.save!
    end
    tournament_result.update!(hb_tournament.updated_player_results(player))
  end
end

# Pour vérifier mes calculs
# fake_tournament = Tournament.create!(name: "FAKE Tournament")
# puts "#{fake_tournament.name} created"

# fake_game_ids = ['337357698', '337731880', '344624175', '346612586', '348273498', '350145852', '352493558', '354523393', '356601454', '357057091', '360574181', '362159900', '362089613', '359272358', '359216685', '356326439', '356279110']

# fake_game_ids.each do |game_id|
#   scrapings = GameScraper.new(game_id).scrape

#   game = Game.find_or_initialize_by(winamax_id: scrapings[:game][:winamax_id])
#   if game.id.nil?
#     game.attributes = scrapings[:game]
#     game.save!

#     scrapings[:results].each do |result|
#       player = Player.find_or_initialize_by(name: result["player_name"])
#       player.name = result["player_name"]
#       player.save!
#       puts "Player #{player.name} created"

#       new_result = Result.new(result.except("player_name"))
#       new_result.player = player
#       new_result.game = game
#       new_result.save!
#       puts "Result for player #{player.name} created"
#     end
#   end

#   puts "Game #{game.name} created"

#   session = Session.new
#   session.game = game
#   session.tournament = fake_tournament
#   session.save!
#   puts "Session for game #{game.name} in fake_tournament #{fake_tournament.name} created"

#   # Update Tournament Result Data
#   scrapings[:results].each do |result|
#     player = Player.find_by_name(result["player_name"])
#     tournament_result = TournamentResult.find_or_initialize_by(player: player, tournament: fake_tournament)
#     if tournament_result.id.nil?
#       tournament_result.player = player
#       tournament_result.tournament = fake_tournament
#       tournament_result.save!
#     end
#     tournament_result.update!(fake_tournament.updated_player_results(player))
#   end
# end

puts "This is the end"

