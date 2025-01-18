# build-harbor-aarch64
Build an offline-deployable Harbor version for ARM64 architecture.

How to get the harbor-offline-installer-aarch64 package?

### Option1 （方法一）
直接从该项目的Release页面下载完整的离线包文件harbor-offline-installer-aarch64-v2.12.2.tgz

### Option2 （方法二）
下载离线镜像包
```
docker pull alanpeng/harbor_images_aarch64:v2.12.2
```

创建一个新的容器实例
```
TEMP_CONTAINER_ID=$(docker create alanpeng/harbor_images_aarch64:v2.12.2 /bin/true)
```

从容器中拷贝文件
```
docker cp $TEMP_CONTAINER_ID:/harbor-offline-installer-aarch64.tgz ./harbor-offline-installer-aarch64.tgz
```

删除容器实例
```
docker rm $TEMP_CONTAINER_ID
```
### 接下来便是正常安装过程了

以正常方式安装Harbor ARM64 Version
```
tar zxf harbor-offline-installer-aarch64.tgz
cd harbor
cp harbor.yml.tmpl harbor.yml
```

适当修改harbor.yml文件内容

vi harbor.yml

```
install.sh
```

![Harbor-v2.12.2-Aarch64](https://github.com/wise2c-devops/build-harbor-aarch64/assets/3273357/49ce7cc3-918e-421c-86d9-2c06e9b42bb3)

### 该项目工作原理（如何解决官方项目无法直接用于构建ARM64架构镜像?）

在我们手头没有ARM设备的时候，如何构建完全基于官方代码的ARM64架构发现包？

在众多免费的SaaS化的CI服务中，对ARM64架构支持体验最好的平台，我曾经用过TravisCI、GitlabCI、CircleCI，前两者已经不完全免费，因此一直都在用CircleCI构建我的工作相关镜像

对于如何使用CircleCI，其实是和TravisCI这样的平台极其类似的，具体可参考这篇文章内容：https://mp.weixin.qq.com/s/PlBvzDlPQbnYTmyQoSLD5Q

如果你希望自己及时构建自己的Harbor ARM64镜像，最简单的方法是fork本项目到你自己github账号，然后修改代码里的镜像名称前缀 alanpeng/ 为你自己的即可。

涉及变更的文件有：

![image](https://github.com/user-attachments/assets/b4a07cbb-5d7f-4c36-9d6c-e175cfa427cc)

然后注册并登录你的CircleCI账号，同步你的github项目后对项目进行设置：

![image](https://github.com/user-attachments/assets/cfbac344-5bd8-42d5-a245-be0b7c03237d)

先注册docker hub账号，也可以是国内比如阿里云镜像仓库账号，然后做好设定：

![image](https://github.com/user-attachments/assets/5d8e91ee-f111-4f93-9fa2-5eec17155965)

后面你只需要针对整个项目里的Harbor的版本变化做更新即可自动获得最新版本的镜像了。

![image](https://github.com/user-attachments/assets/7e7a6b6a-6b8b-40ac-97f2-f1c7a55efb98)

每次提交代码变更，CircleCI会自动开始构建，如果失败可查看日志调整脚本或相关代码即可：

![image](https://github.com/user-attachments/assets/8afb596c-8695-49d0-a4cd-07dc46f86b3d)

![image](https://github.com/user-attachments/assets/d8b4064b-aa42-40eb-84c7-8d7420f46780)
