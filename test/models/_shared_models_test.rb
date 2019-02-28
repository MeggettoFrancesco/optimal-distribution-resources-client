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

  private

  def check_negative_and_positive_limits(object, attribute)
    object.send("#{attribute}=", 0)
    assert object.invalid?

    object.send("#{attribute}=", 2)
    assert object.valid?
  end
end
