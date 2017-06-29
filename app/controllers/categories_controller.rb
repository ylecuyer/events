class CategoriesController < ApplicationController
  def create

    authorize Category
 
    @event = Event.find params[:event_id]
    @attendee = Attendee.new

    @category = Category.new(category_params)
    @category.event = @event

    if @category.save
      redirect_to @event, notice: 'Category was successfully created.'
    else
      puts @category.errors.inspect
      render 'events/show'
    end
  end

  def new
	  @event = Event.find params[:event_id]
	  @category = Category.new
	  authorize @category
  end

  def index
    @event = Event.find params[:event_id]
    authorize @event
    @categories = @event.categories
  end

  def edit
	  @event = Event.find params[:event_id]
	  @category = Category.find params[:id]
	  authorize @category
  end

  def update
	  @event = Event.find params[:event_id]
	  @category = Category.find params[:id]
		authorize @event

    if @category.update(category_params)
      redirect_to event_categories_path(@event), notice: 'Category was successfully updated.' 
    else
      render :edit
    end
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end
end
