.PHONY: build serve clean

serve:
	zola serve

build:
	zola build

clean:
	rm -rf public
