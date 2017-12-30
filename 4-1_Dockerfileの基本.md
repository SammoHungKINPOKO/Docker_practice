## Dockerの実行

### Docker Quickstart Terminal
Docker Quickstart Terminalアイコンから実行する。
> マシン名: default <br/>
> IPアドレス: 192.168.99.100

### 作成された仮想環境にSSHでアクセス
```
$ docker-machine ssh default
```

### Dockerのディレクトリ
開始時は以下の通り。
```
docker@default:~$ pwd
/home/docker
```

## DockerfileからDockerイメージの作成
```
docker build -t [生成するイメージ名]:[タグ名] [Dockerfileの場所]
```

### Dockerfileの作成
```
docker@default:~$ pwd
/home/docker
docker@default:~$ mkdir sample && cd $_
docker@default:~/sample$ touch Dockerfile
docker@default:~/sample$ ls
Dockerfile
```

### Dockerfileを記述する。
```Dockerfile
FROM centos:centos7
```

### コマンドの実行
```
docker@default:~$ pwd
/home/docker
docker@default:~$ docker build -t sample:1.0 /home/docker/sample
Sending build context to Docker daemon  2.048kB
Step 1/1 : FROM centos:centos7
centos7: Pulling from library/centos
Digest: sha256:3b1a65e9a05f0a77b5e8a698d3359459904c2a354dc3b25ae2e2f5c95f0b3667
Status: Downloaded newer image for centos:centos7
 ---> 3fa822599e10
Successfully built 3fa822599e10
Successfully tagged sample:1.0
```

コマンドを実行すると、`/home/docker/sample`に格納したDockerfileからsampleという名前のDockerイメージが生成される。
初回はDockerリポジトリからベースイメージをダウンロードする処理があるので時間がかかるが、逐次Dockerfileの内容が実行されいるのが分かる。

#### docker imageコマンドで確認すると、生成したsample:1.0の2つのイメージが出来ているのがわかる。
```
docker@default:~$ docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
ubuntu                        latest              00fd29ccc6f1        2 weeks ago         111MB
centos                        7                   3fa822599e10        4 weeks ago         204MB
centos                        centos7             3fa822599e10        4 weeks ago         204MB
sample                        1.0                 3fa822599e10        4 weeks ago         204MB
kitematic/hello-world-nginx   latest              03b4557ad7b9        2 years ago         7.91MB
```
2回目以降はベースイメージをDockerレジストリからダウンロードしないため、すぐにイメージの作成ができる。

### 任意のファイル名を付けたDockerfileを実行する
```
docker@default:~$ docker build -t sample -f Dockerfile.base .
```
ファイル名は`-f`コマンドで指定する。カレントディレクトリは`.`で表す。

### 標準入力からのビルド
```
docker@default:~$ docker build - < Dockerfile
```
標準入力の内容としてDockerfileの中身をdocker buildコマンドの引数に渡すため、`-`を指定する。


## Dockerイメージのレイヤー構造
Dockerfileの命令ごとにイメージを作成する。作成された複数のイメージはレイヤー構造となっている。
```Dockerfile
# 0. CentOS（ベースイメージ）
FROM centos:latest

# 1. Apacheのインストール
RUN  yum install -y httpd

# 2. ファイルのコピー
COPY index/html /var/www/html

# 3. Apacheの起動
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

### Dockerイメージの作成
このDockerfileをもとにdocker buildコマンドでイメージを作成する。
```
docker@default:~/sample$ docker build -t sample .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM centos:centos7
 ---> 3fa822599e10
Step 2/4 : RUN yum install -y httpd
 ---> Running in 6d67d05cc52b
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.4.6-67.el7.centos.6 will be installed
--> Processing Dependency: httpd-tools = 2.4.6-67.el7.centos.6 for package: httpd-2.4.6-67.el7.centos.6.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-67.el7.centos.6.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-67.el7.centos.6.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-67.el7.centos.6.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-67.el7.centos.6.x86_64
--> Running transaction check
---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
---> Package centos-logos.noarch 0:70.0.6-3.el7.centos will be installed
---> Package httpd-tools.x86_64 0:2.4.6-67.el7.centos.6 will be installed
---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch        Version                       Repository    Size
================================================================================
Installing:
 httpd             x86_64      2.4.6-67.el7.centos.6         updates      2.7 M
Installing for dependencies:
 apr               x86_64      1.4.8-3.el7_4.1               updates      103 k
 apr-util          x86_64      1.5.2-6.el7                   base          92 k
 centos-logos      noarch      70.0.6-3.el7.centos           base          21 M
 httpd-tools       x86_64      2.4.6-67.el7.centos.6         updates       88 k
 mailcap           noarch      2.1.41-2.el7                  base          31 k

Transaction Summary
================================================================================
Install  1 Package (+5 Dependent packages)

Total download size: 24 M
Installed size: 32 M
Downloading packages:
Public key for apr-util-1.5.2-6.el7.x86_64.rpm is not installed
warning: /var/cache/yum/x86_64/7/base/packages/apr-util-1.5.2-6.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for apr-1.4.8-3.el7_4.1.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                              856 kB/s |  24 MB  00:29
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-4.1708.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/6
  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/6
  Installing : httpd-tools-2.4.6-67.el7.centos.6.x86_64                     3/6
  Installing : centos-logos-70.0.6-3.el7.centos.noarch                      4/6
  Installing : mailcap-2.1.41-2.el7.noarch                                  5/6
  Installing : httpd-2.4.6-67.el7.centos.6.x86_64                           6/6
  Verifying  : mailcap-2.1.41-2.el7.noarch                                  1/6
  Verifying  : httpd-2.4.6-67.el7.centos.6.x86_64                           2/6
  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  3/6
  Verifying  : httpd-tools-2.4.6-67.el7.centos.6.x86_64                     4/6
  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   5/6
  Verifying  : centos-logos-70.0.6-3.el7.centos.noarch                      6/6

Installed:
  httpd.x86_64 0:2.4.6-67.el7.centos.6

Dependency Installed:
  apr.x86_64 0:1.4.8-3.el7_4.1
  apr-util.x86_64 0:1.5.2-6.el7
  centos-logos.noarch 0:70.0.6-3.el7.centos
  httpd-tools.x86_64 0:2.4.6-67.el7.centos.6
  mailcap.noarch 0:2.1.41-2.el7

Complete!
 ---> fa94e3599a99
Removing intermediate container 6d67d05cc52b
Step 3/4 : COPY index/html /var/www/html
COPY failed: stat /mnt/sda1/var/lib/docker/tmp/docker-builder076183314/index/html: no such file or directory
docker@default:~/sample$
```
`Step 3/4`の途中で失敗してしまいました。

### ログ
命令1行ごとにイメージが生成されている。複数のイメージを積み重ねるイメージ。
また、共通のベースイメージをもとに複数のイメージを作成した場合、ベースイメージは共有される。