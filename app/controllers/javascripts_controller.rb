class JavascriptsController < ApplicationController
  def i18n
    cache_for 2.hours
  end
end
