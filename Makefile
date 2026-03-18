website:
	rm -rf public
	hugo --buildFuture
	@if grep -R "raw HTML omitted" docs/public ; then echo "ERROR: found unescaped HTML - fix the markdown source" ; fi

upload_website:	website
	rclone -P --exclude "/pub/**" --exclude "venv/**" sync public/ box:public_html/

upload_test_website:	website
	rclone -P --exclude "/pub/**" --exclude "venv/**" sync public/ box:public_html_new/

validate_website: website
	@find public -type f -name "*.html" -print0 | \
		xargs -0 tidy --mute-id yes -errors --gnu-emacs yes --drop-empty-elements no --warn-proprietary-attributes no --mute MISMATCHED_ATTRIBUTE_WARN --mute MOVED_STYLE_TO_HEAD 2>&1 | \
		tee /tmp/tidy-output.txt | grep -E ': (Warning|Error):' || true
	@if grep -qE ': (Warning|Error):' /tmp/tidy-output.txt; then echo "Validation issues found (see above)"; exit 1; fi
	@echo "HTML validation passed"

serve:	website
	hugo server --buildFuture --logLevel info -w --disableFastRender
