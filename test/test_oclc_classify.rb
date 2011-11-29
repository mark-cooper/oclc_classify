require "shoulda"
require "oclc_classify"

class TestOclcClassify < Test::Unit::TestCase
	
	context "" do

  		setup do
	    	@oclc = OCLC::Classify.new 'oclc', '123456'
	    	@isbn = OCLC::Classify.new 'isbn', '987654321', true
	    	@oclc.classify
	    	@isbn.classify
  		end
  		
  		should "Have constructed correct url" do 
  			assert_equal 'http://classify.oclc.org/classify2/Classify?oclc=123456&summary=false', @oclc.url
  			assert_equal 'http://classify.oclc.org/classify2/Classify?isbn=987654321&summary=true', @isbn.url
  		end

  	end

end
