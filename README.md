# README
>Dockerの練習です。
>Docker, Rails, MySQL, TailWind CSS
--------------------------
### メモ
* dockerfileがrails new . をしたら勝手に上書きされてしまうので拡張子を.devにする。
* docker-compose.ymlでversion設定不要。
* Rails7以降は、WebpackerがデフォルトでインストールされなくなるためNode.jsは、不要
* css適応されない時に,docker compose exec web rails tailwindcss:build
* docker compose run web rails db:migrate

### rubocop
> docker compose run web bundle exec rubocop
* docker compose run web bundle exec rubocop -a
> rubocopが指摘した問題を自動的に修正してくれる

#### 1.作業ディレクトリ作成
```
mkdir bbs_app
cd bbs_app

touch Dockerfile.dev docker-compose.yml Gemfile Gemfile.lock entrypoint.sh
```
#### 2.ファイル準備
###### Dockerfile.dev
```
FROM ruby:3.2.2
ARG RUBYGEMS_VERSION=3.3.20

# 作業ディレクトリを指定
WORKDIR /bbs_app

# ホストのGemfileをコンテナ内の作業ディレクトリにコピー
COPY Gemfile Gemfile.lock /bbs_app/

# bundle installを実行
RUN bundle install

# ホストのファイルをコンテナ内の作業ディレクトリにコピー
COPY . /bbs_app/

# entrypoint.shをコンテナ内の作業ディレクトリにコピー
COPY entrypoint.sh /usr/bin/

# entrypoint.shの実行権限を付与
RUN chmod +x /usr/bin/entrypoint.sh

# コンテナ起動時にentrypoint.shを実行するように設定
ENTRYPOINT ["entrypoint.sh"]

# コンテナ起動時に実行するコマンドを指定
CMD ["rails", "server", "-b", "0.0.0.0"]
```
###### docker-compose.yml
* db という欄で MySQL (DB) のコンテナの起動に関する設定
* web という欄で Rails (アプリ) サービス起動に関する設定
```
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - mysql_volume:/var/lib/mysql
    ports:
      - '3306:3306'
    command: --default-authentication-plugin=mysql_native_password

  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails tailwindcss:build && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/bbs_app
    ports:
      - 3000:3000
    stdin_open: true
    tty: true
    depends_on:
      - db
volumes:
  mysql_volume:
```
###### Gemfile
```
source 'https://rubygems.org'
gem 'rails', '~> 7.0'
```
###### entrypoint.sh
* entrypoint.sh は、コンテナ起動時に実行するスクリプトを記述するためのファイル
*  server.pid のエラーを回避するために、 一度 server.pid を削除
>exec "$@" は、コンテナ起動時に実行するコマンドを指定するためのものです。
これにより、Dockefile で指定した CMD ["rails", "server", "-b", "0.0.0.0"] が実行
```
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /bbs_app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
```
#### 3.Rails雛形作成
```
docker-compose run web rails new . --force --no-deps --database=mysql --css=tailwind --skip-jbuilder --skip-action-mailbox --skip-action-mailer --skip-test
```
#### 4.Dockerコンテナイメージの作成
```
docker compose build
```
#### 5.MySQL データベースの準備
###### config/database.ymlを編集
> host欄のdb は docker-compose.yml で指定した MySQL のコンテナ名
```
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: user
  password: password
  host: db

development:
  <<: *default
  database: bbs_app_development

test:
  <<: *default
  database: bbs_app_test
```
#### 6.データーベース作成
```
docker compose run web rails db:create
```
>これをするとMySQLに接続しようとしたら、指定されたユーザー（'user'）がデーターベースにアクセス権限がないと言われるのでコンテナに接続して権限を付与する。
```
docker compose exec db mysql -u root -p
```
>MySQLコンテナに接続
```
GRANT ALL PRIVILEGES ON bbs_app_development.* TO 'user'@'%';
FLUSH PRIVILEGES;
```
>(user に bbs_app_development データベースへの全権限を付与)
```
GRANT ALL PRIVILEGES ON bbs_app_test.* TO 'user'@'%';
FLUSH PRIVILEGES;
```
>(user に bbs_app_test データベースへの全権限を付与)
###### データベース作成の再試行
```
docker compose run web rails db:create
```
#### 7.コンテナを起動
> -dオプションでバックグランドで起動
```
docker-compose up -d
```
>コンテナを起動
```
docker compose ps
```
>起動したコンテナを確認(STATUSnにrunningと出れば🙆‍♂️)
#### 8. 最後にサーバの再起動
```
docker compose restart
```

#####　補足🚀
>コンテナを停止させる
```
docker compose stop
```
>また開発するとき()
```
docker compose up -d
```
>エラーが出たときにログ確認
```
docker compose logs
```
>コンテナを停止して削除する
```
docker compose down
```

-------------------------------
##### ローカルの変更がリモートの変更と衝突した時
```
git stash
```
* 1.変更を一時的に保存する：ローカルの変更を一時的にスタッシュする
* 2.リモートの変更を取り込む：スタッシュした後に、再度git pull origin mainを実行

```
git stash pop
```
* 3.スタッシュを復元する：リモートの変更を取り込んだ後、スタッシュした変更を復元する
