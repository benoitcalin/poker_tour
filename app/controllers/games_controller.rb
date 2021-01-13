class GamesController < ApplicationController
  def create
    @tournament = Tournament.find(params[:tournament_id])
    @game = Game.find_or_initialize_by(winamax_id: game_params[:winamax_id])

    unless Session.where(game: @game, tournament: @tournament).empty?
      redirect_to tournament_path(@tournament), alert: "Cette partie est déjà associée au tournoi."
      return
    end

    scrapings = GameScraper.new(game_params[:winamax_id]).scrape

    if @game.id.nil?
      @game.attributes = scrapings[:game]
      @game.save
      scrapings[:results].each do |result|
        find_or_create_players(result)
        create_result(result, @game)
      end
    end

    Session.create(game: @game, tournament: @tournament)

    update_tournament_results(scrapings[:results], @tournament)
    redirect_to tournament_path(@tournament), notice: "La partie a bien été ajoutée ! Si ça n'est pas le cas, contactez le développeur ;)"
  end

  private

  def game_params
    params.require(:game).permit(:winamax_id)
  end

  def find_or_create_players(result)
    player = Player.find_or_initialize_by(name: result["player_name"])
    player.name = result["player_name"]
    player.save
  end

  def create_result(result, game)
    new_result = Result.new(result.except("player_name"))
    player = Player.find_by_name(result["player_name"])
    # if result['position'] == 1
    #   other_bounties = game.total_registrations * game.bounty - new_result.bounties
    #   new_result.kills = game.bounty > 0 ? (((new_result.bounties - other_bounties) / game.bounty) - 1.0) : 0.00
    # else
    #   new_result.kills = game.bounty > 0 ? new_result.bounties / (game.bounty / 2.0) : 0.00
    # end
    new_result.player = player
    new_result.game = game
    new_result.save
  end

  def update_tournament_results(results, tournament)
    results.each do |result|
      player = Player.find_by_name(result["player_name"])
      tournament_result = TournamentResult.find_or_initialize_by(player: player, tournament: tournament)
      if tournament_result.id.nil?
        tournament_result.player = player
        tournament_result.tournament = tournament
        tournament_result.save
      end
      tournament_result.update(tournament.updated_player_results(player))
    end
  end
end
