# ベースイメージの設定
FROM centos:centos7

# ダイジェストを指定したDockerfile
# ベースイメージの設定
# イメージ名の後ろに@をつけ、ダイジェストの値を指定する。
# DIGESTの値は、'docker images --digests'コマンドで指定できる。
FROM kitematic/hello-world-nginx@sha256:ec0ca6dcb034916784c988b4f2432716e2e92b995ac606e080c7a54b52b87066

# Dockerfileの作成者を記述する
MAINTAINER sammohung KINPOKO <h0534jokt@gmail.com>

# イメージを作成する


