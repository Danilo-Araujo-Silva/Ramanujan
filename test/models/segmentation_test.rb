require 'test_helper'

class SegmentationTest < ActiveSupport::TestCase
  test "should not save empty segmentation" do
    segmentation = Segmentation.new

    assert_not segmentation.save
  end

  test "should not save segmentation without title, description, query" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'

    assert_not segmentation.save
  end

  test "should not save segmentation without title, description" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'

    assert_not segmentation.save
  end

  test "should not save segmentation without title" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."

    assert_not segmentation.save
  end

  test "should not save segmentation with empty title" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = ""

    assert_not segmentation.save
  end

  test "should not save segmentation with blank title" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = " "

    assert_not segmentation.save
  end

  test "should not save segmentation with empty description" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = ""
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end

  test "should not save segmentation with blank description" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = " "
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end

  test "should save segmentation with empty query and parameters" do
    segmentation = Segmentation.new
    segmentation.parameters = ""
    segmentation.query = ""
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end

  test "should not save segmentation with unsparsable query" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"], ["30"]]'
    segmentation.query = ']["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end

  test "should not save segmentation with unsparsable parameters" do
    segmentation = Segmentation.new
    segmentation.parameters = '][["SC"], ["30"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end

  test "should not save segmentation with incorrect query with parameters" do
    segmentation = Segmentation.new
    segmentation.parameters = '[["SC"]]'
    segmentation.query = '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]'
    segmentation.description = "Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos."
    segmentation.title = "Residentes em SC Maiores de 30 Anos"

    assert_not segmentation.save
  end
end
