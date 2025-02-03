class Api::V1::RenewalRequestsController < ApiController
  def create
    borrowing = Borrowing.find_by(id: params[:borrowing_id])

    if borrowing.nil?
      render json: { error: "Borrowing not found" }, status: :not_found
      return
    end

    if borrowing.renewal_requests.exists?(is_approved: false)
      render json: { error: "A renewal request already exists for this borrowing." }, status: :unprocessable_entity
      return
    end

    renewal_request = borrowing.renewal_requests.create(is_approved: false)

    if renewal_request.persisted?
      render json: renewal_request, status: :created
    else
      render json: { error: "Failed to create renewal request" }, status: :unprocessable_entity
    end
  end

  private

  def renewal_request_params
    params.require(:renewal_request).permit(:is_approved)
  end
end
