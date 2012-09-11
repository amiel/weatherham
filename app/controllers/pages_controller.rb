class PagesController < ApplicationController

  def changelog
    @changelog ||= begin
      lines = Rails.root.join('CHANGELOG.textile').read
      RedCloth.new(lines.to_s).to_html
    end

    fresh_when(etag: Digest::SHA1.hexdigest(@changelog), public: true)
  end

  def todo
    @todo ||= begin
      lines = Rails.root.join('TODO.textile').read
      RedCloth.new(lines.to_s).to_html
    end

    fresh_when(etag: Digest::SHA1.hexdigest(@todo), public: true)
  end
end
