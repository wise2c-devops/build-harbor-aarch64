GIT_BRANCH="v2.9.0"

# first step: clone harbor ARM code
git clone https://github.com/goharbor/harbor-arm.git

# execute build command：Download harbor source code
cd harbor-arm
git clone https://github.com/goharbor/harbor.git
cd harbor
git checkout $GIT_BRANCH
cd ..

# compile redis:
make compile_redis

# Prepare to build arm architecture image data:
make prepare_arm_data

# Replace build arm image parameters：
make pre_update

# Compile harbor components:
make compile COMPILETAG=compile_golangimage

# Build harbor arm image:
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true NOTARYFLAG=true TRIVYFLAG=true CHARTFLAG=true GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false
