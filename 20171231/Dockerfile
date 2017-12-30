# 0. CentOS（ベースイメージ）
FROM centos:latest

# 1. Apacheのインストール
RUN  yum install -y httpd

# 2. ファイルのコピー
COPY index/html /var/www/html

# 3. Apacheの起動
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]