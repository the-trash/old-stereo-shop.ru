class LineItemsController < FrontController
  before_filter :set_line_item, except: :create

  def create
    @product = Product.find(params[:product_id])
    @line_item = @cart.add_product(@product.id)

    if @line_item.save
      flash!(:success)
    else
      flash!(:error)
    end

    redirect_to :back
  end

  def update
    @line_item.update_column(:quantity, quantity) if quantity > 0

    respond_to do |format|
      format.html { redirect_to @cart, flash: :success }
      format.json { render json: @line_item }
    end
  end

  def destroy
    @line_item.destroy
    redirect_to @cart, flash: :success
  end

  private

  def set_line_item
    @line_item = @cart.line_items.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  def quantity
    line_item_params[:quantity].to_i
  end
end
