info:
	@echo Sum Checker
	@echo ---------------------
	@echo USAGE:
	@echo SUM=200.0 PRESET=dashbox FILE=/path/to/csv/file make check-sum
	@echo
	@echo Track Numberer
	@echo ---------------------
	@echo USAGE:
	@echo dashbox FILE=/path/to/csv/file make check-sum
	@echo
test:
	bundle exec rspec spec/
check-sum:
	ruby ./sum_checker_cli.rb $(FILE) $(PRESET) $(SUM)
number-track:
	ruby ./track_numberer_cli.rb $(FILE)
