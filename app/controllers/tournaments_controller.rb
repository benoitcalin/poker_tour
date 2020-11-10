class TournamentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  helper_method :sort_column, :sort_direction

  def index
    @tournaments = Tournament.all
  end

  def show
    allis = ['Magrande', 'Mougne69', 'Elcasador', 'Geo8535', 'jukebox91210', 'ritouns', 'StevOLRRR', 'leotom7576', 'KensBanker', 'Chaton96', 'Sakorh']
    @tournament = Tournament.find(params[:id])
    @game = Game.new
    if params[:query] && params["sort"]
      @stats = sortable_column_order(@tournament.tournament_results.includes(:player)).select { |tr| allis.include?(tr.player.name) }
    elsif params[:query]
      @stats = @tournament.tournament_results.includes(:player).select { |tr| allis.include?(tr.player.name) }
    elsif params["sort"]
      @stats = sortable_column_order(@tournament.tournament_results.includes(:player))
    else
      @stats = @tournament.tournament_results.includes(:player).order("earnings desc")
    end
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.user = current_user
    if @tournament.save
      Participation.create(user: current_user, tournament: @tournament)
      redirect_to tournament_path(@tournament)
    else
      render :new
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name)
  end

  def sortable_column_order(base)
    base.order("#{sort_column} #{sort_direction}")
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
  end

  def sort_column
    authorize_sortable_column.include?(params[:sort]) ? params[:sort] : "earnings"
  end

  def authorize_sortable_column
    ["games", "average_position", "reentries", "bets", "earnings", "net_earnings", "earnings_by_game", "kills"]
  end
end
