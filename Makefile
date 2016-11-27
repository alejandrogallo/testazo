PREFIX   ?= /usr/bin
DIST     ?= dist
SRC      ?= src
BUILD    ?= build
BIN_NAME ?= testazo.sh
MAIN_BIN ?= $(DIST)/$(BIN_NAME)

SOURCES  ?= $(wildcard $(SRC)/*)


.PHONY: clean clean-test test test-debug test-list

.DEFAULT_TARGET = $(MAIN_BIN)

$(MAIN_BIN): $(SOURCES)
	./tools/compile.sh -b $(BUILD) -d $(DIST) -o $(BIN_NAME) src/main.sh

clean:
	rm -rf dist build

TEST_SCRIPT = test/testazo.sh

$(TEST_SCRIPT): $(MAIN_BIN)
	cp $< $@

clean-test:
	-rm $(TEST_SCRIPT)

test: clean-test $(TEST_SCRIPT) ## Run tests in test
	@./test/testazo.sh

test-debug: clean-test $(TEST_SCRIPT)
	@./test/testazo.sh -d

test-list: clean-test $(TEST_SCRIPT)
	@./test/testazo.sh -l

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

