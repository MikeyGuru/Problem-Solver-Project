class NotesController < ApplicationController
  before_action :authenticate
  before_action :set_note, only: [:destroy, :update, :choose]

  def index
    @notes = Note.all
  end
  def new
    @note = Note.new
  end
  def show
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @note = current_user.notes.build(note_params)
    @note.problem = @problem

  respond_to do |format|
    format.html do
    if @note.save
      redirect_to @problem, success: "Note created."
    else
      redirect_to @problem
    end
  end

    format.js do
        if @note.save
          render "notes/create", status: :created
        else
          render nothing: true, status: :bad_request
        end
      end
    end
  end

  def destroy
    if @note.destroy
      redirect_to @note.problem
    end
  end

  def update
  end

  def choose
    @problem = @note.problem

    if @note.update(chosen: true) && @problem.update(resolved: true)
      redirect_to @problem, success: "Problem has been closed and removed from open problems list."
    else
      redirect_to @problem
    end
  end

  private

  def note_params
    params.require(:note).permit(:user, :comment, :chosen, :name)
  end

  def set_note
		@note = Note.find(params["id"])
  end

end
