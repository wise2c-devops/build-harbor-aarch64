#!/bin/bash

# 定义目标仓库的前缀
TARGET_REPO_PREFIX="amy520"

# 需要排除的关键字数组
EXCLUDE_KEYWORDS=("golang" "node" "alpine")  # 你可以根据需要添加或删除关键字

# 获取所有容器镜像
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}")

# 遍历所有镜像
for IMAGE in $IMAGES; do
    # 对于每一个排除关键字
    SKIP=false
    for KEYWORD in "${EXCLUDE_KEYWORDS[@]}"; do
        # 如果镜像名称包含排除的关键字，则设置SKIP为true
        if echo $IMAGE | grep -q $KEYWORD; then
            SKIP=true
            break
        fi
    done

    # 如果SKIP为true，则跳过当前的镜像
    if $SKIP; then
        echo "Skipping $IMAGE due to exclusion keyword"
        continue
    fi

    # 获取镜像的名称和标签
    REPO_NAME=$(echo $IMAGE | cut -d ':' -f 1 | rev | cut -d '/' -f 1 | rev)  # 这里我们反转字符串，以便从最后一个'/'分割，然后再次反转回来
    TAG=$(echo $IMAGE | cut -d ':' -f 2)

    # 生成新的镜像名称和标签
    NEW_IMAGE="${TARGET_REPO_PREFIX}/${REPO_NAME}:$TAG"

    # 打印信息
    echo "Tagging $IMAGE as $NEW_IMAGE"

    # 标记镜像
    docker tag $IMAGE $NEW_IMAGE

    # 打印信息
    echo "Pushing $NEW_IMAGE"

    # 推送镜像
    docker push $NEW_IMAGE
done
