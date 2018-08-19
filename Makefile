run:
	bundle exec rails s -b 0.0.0.0 -p 8029

test:
	RAILS_ENV=test bundle exec rspec
