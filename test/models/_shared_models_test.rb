module SharedModelsTest
  def invalid_without(object, attribute)
    object.send("#{attribute}=", nil)
    invalid_and_error_present(object, attribute)
  end

  def invalid_and_error_present(object, attribute)
    assert object.invalid?
    assert_not_nil object.errors[attribute.to_sym]
  end

  def valid_if_greater_than_one(object, attribute)
    object.send("#{attribute}=", 1)
    assert object.valid?

    check_negative_and_positive_limits(object, attribute)
  end

  def create_api_request_creates_job(my_request)
    Sidekiq::Worker.clear_all
    my_request.send('create_api_request')
    assert_equal 1, OdrCreateApiRequestWorker.jobs.size
  end

  def check_coordinates(nested_request)
    perform_odr_api_calls(nested_request.request)

    coordinates = nested_request.coordinates
    expected_coordinates = nested_request.request.coordinates

    assert_equal expected_coordinates, coordinates
  end

  def perform_odr_api_calls(my_request)
    Sidekiq::Worker.clear_all
    my_request.save!

    stub_odr_api_request(my_request)
    OdrCreateApiRequestWorker.drain
    my_request.reload
    stub_odr_api_solution_request(my_request)
    OdrFetchApiSolutionWorker.drain

    my_request.reload
  end

  private

  def check_negative_and_positive_limits(object, attribute)
    object.send("#{attribute}=", 0)
    assert object.invalid?

    object.send("#{attribute}=", 2)
    assert object.valid?
  end
end
