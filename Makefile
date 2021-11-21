website:
	rm -rf public
	hugo
	@if grep -R "raw HTML omitted" docs/public ; then echo "ERROR: found unescaped HTML - fix the markdown source" ; fi

upload_website:	website
	-#rclone -v sync public memstore:www-rclone-org

upload_test_website:	website
	-#rclone -P sync public test-rclone-org:

validate_website: website
	find public -type f -name "*.html" | xargs tidy --mute-id yes -errors --gnu-emacs yes --drop-empty-elements no --warn-proprietary-attributes no --mute MISMATCHED_ATTRIBUTE_WARN

serve:	website
	hugo server -v -w --disableFastRender
