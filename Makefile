BUILD_VERSION   := $(shell git describe --tag)
BUILD_DATE      := $(shell date "+%F %T")
COMMIT_SHA1     := $(shell git rev-parse HEAD)

all:
	gox -osarch="darwin/amd64 linux/386 linux/amd64" \
        -output="dist/{{.Dir}}_{{.OS}}_{{.Arch}}" \
    	-ldflags   "-s -w -X 'github.com/mritd/idgen/cmd.Version=${BUILD_VERSION}' \
                    -X 'github.com/mritd/idgen/cmd.BuildDate=${BUILD_DATE}' \
                    -X 'github.com/mritd/idgen/cmd.CommitID=${COMMIT_SHA1}'"

release: all
	ghr -u mritd -t $(GITHUB_TOKEN) -replace -recreate --debug ${BUILD_VERSION} dist

pre-release: all
	ghr -u mritd -t $(GITHUB_TOKEN) -replace -recreate -prerelease --debug ${BUILD_VERSION} dist

clean:
	rm -rf dist

install:
	go install -ldflags "-s -w -X 'github.com/mritd/idgen/cmd.Version=${BUILD_VERSION}' \
                         -X 'github.com/mritd/idgen/cmd.BuildDate=${BUILD_DATE}' \
                         -X 'github.com/mritd/idgen/cmd.CommitID=${COMMIT_SHA1}'"

docker:
	docker build -t mritd/idgen:${BUILD_VERSION} .

.PHONY: all release clean install

.EXPORT_ALL_VARIABLES:

GO111MODULE = on
GOPROXY = https://goproxy.cn
