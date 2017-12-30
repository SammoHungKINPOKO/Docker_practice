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
