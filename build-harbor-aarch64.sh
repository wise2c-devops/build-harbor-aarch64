GIT_BRANCH="v2.10.0"

# first step: clone harbor ARM code
git clone https://github.com/alanpeng/harbor-arm.git

# Replace dev-arm image tag
sed -i "s#dev-arm#${GIT_BRANCH}-arm#g" harbor-arm/Makefile

# execute build command：Download harbor source code
cd harbor-arm
git clone --branch ${GIT_BRANCH} https://github.com/goharbor/harbor.git src/github.com/goharbor/harbor
cp -f ../harbor/Makefile src/github.com/goharbor/harbor/
cp -f ../harbor/make/photon/Makefile src/github.com/goharbor/harbor/make/photon/

# compile redis
make compile_redis

# Prepare to build arm architecture image data:
make prepare_arm_data

# Replace build arm image parameters：
make pre_update

# Compile harbor components:
make compile COMPILETAG=compile_golangimage

# Build harbor arm image:
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true TRIVYFLAG=true GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false
