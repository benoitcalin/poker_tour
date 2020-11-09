class TournamentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]


  def index
    @tournaments = Tournament.all
  end

  def show
    allis = ['Magrande', 'Mougne69', 'Elcasador', 'Geo8535', 'jukebox91210', 'ritouns', 'StevOLRRR', 'leotom7576', 'KensBanker', 'Chaton96', 'Sakorh']
    @tournament = Tournament.find(params[:id])
    if params[:query] === "allis"
      @stats = @tournament.tournament_results.includes(:player).select { |tr| allis.include?(tr.player.name) }
    else
      @stats = @tournament.tournament_results.includes(:player)
    end
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
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
end
