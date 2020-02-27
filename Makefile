include $(shell bash .mkdkr init)

lint.shellcheck:
	@$(dkr)
	instance: koalaman/shellcheck-alpine
	run: shellcheck enable-fullscreen.sh
