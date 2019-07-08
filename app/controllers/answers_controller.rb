# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer succesfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      message = { notice: 'Answer deleted.' }
    else
      message = { alert: 'You are not the author of this answer.' }
    end

    redirect_to @answer.question, message
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
