# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# カラム削除のコマンド(migrationファイルを作成し、migrateを実行)
# rails generate migration RemoveScheduleContentIdFromSchedules schedule_content_id:integer
# rails db:migrate

# カラム編集のコマンド(migrationファイルを作成し、migrateを実行。started_at)
# rails g migration ChangeDatatypeStartedAtOfScheduleContents
# ※マイグレーションファイルに追記 -> change_column :schedule_contents, :started_at, :string, :limit=>8
# rails db:migrate

# カラム編集のコマンド(migrationファイルを作成し、migrateを実行。started_at)
# rails g migration ChangeDatatypeEndedAtOfScheduleContents
# ※マイグレーションファイルに追記 -> change_column :schedule_contents, :ended_at, :string, :limit=>8
# rails db:migrate

# カラム削除のコマンド(migrationファイルを作成し、migrateを実行)
# rails generate migration RemoveContentIdFromSchedules content_id:integer
# schedule_content_id以外の名前(content_id)という名前で schedule_contents.id への外部キー制約を持つカラムを作成し制約をはる
# rails g migration AddContentIdToSchedules ContentId:references
# ※マイグレーションファイルに記載 -> add_reference :schedules, :content, foreign_key: { to_table: :schedule_contents }
# rails db:migrate

# テストデータの作成。Symitems_on_Railsディレクトリ配下でコマンドrake db:seedを実行する。
# 注意：以下のデータと共通のdetailをinsertしないこと。
# 注意：以下のデータはupdate、deleteをしないこと。

# テーブル構造確認用SQL
# .schema

# データ確認用SQL
# select * from users;
# select * from Schedule_contents;
# select * from Schedules;

Schedule.delete_all
ScheduleContent.delete_all
User.delete_all

# テストユーザー。2人
User.create!(
  [
    {
      name: '小黒 隼人',
      # password_digest: BCrypt::Password.create('gerounnko'),
      is_admin: '1',
      password: 'gerounnko',
      password_confirmation: 'gerounnko',
      email: 'gerounnko@gmail.com',
      last_login_at: DateTime.now,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    {
      name: '山黒 集太',
      # password_digest: BCrypt::Password.create('chirichirige'),
      is_admin: '0',
      password: 'chirichirige',
      password_confirmation: 'chirichirige',
      email: 'chirichirige@gmail.com',
      last_login_at: DateTime.now,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
  ]
)

# 予定の詳細。5つ
ScheduleContent.create!(
  [
    {
      title: '仕事',
      started_at: '06:00:00',
      ended_at: '18:00:00',
      detail: '小黒まず働く',
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    {
      title: '残業',
      started_at: '18:00:00',
      ended_at: '23:00:00',
      detail: '小黒再び働く',
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    {
      title: '休日出勤に気が付く',
      started_at: '18:00:00',
      ended_at: '23:00:00',
      detail: '小黒またも休日出勤',
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    {
      title: '帰省失敗',
      started_at: '10:00:00',
      ended_at: '10:30:00',
      detail: '小黒も山黒もバスをとり間違える',
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    {
      title: '密漁',
      started_at: '12:00:00',
      ended_at: '18:00:00',
      detail: '山黒カニをたくさんとる',
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
  ]
)

oguro    = User.find_by(email: 'gerounnko@gmail.com')
yamaguro = User.find_by(email: 'chirichirige@gmail.com')

scheduleContentIdWork        = ScheduleContent.find_by(detail: '小黒まず働く')
scheduleContentReWork        = ScheduleContent.find_by(detail: '小黒再び働く')
scheduleContentReHolidayWork = ScheduleContent.find_by(detail: '小黒またも休日出勤')
scheduleContentMissReturn    = ScheduleContent.find_by(detail: '小黒も山黒もバスをとり間違える')
scheduleContentPoaching      = ScheduleContent.find_by(detail: '山黒カニをたくさんとる')

# 予定。6つ
Schedule.create!(
  [
    { # 小黒の予定。同一ユーザー同一日の複数詳細のテスト。
      date: '2020-04-26',
      user_id: oguro.id,
      content_id: scheduleContentIdWork.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    { # 小黒の予定。同一ユーザー同一日の複数詳細のテスト。
      date: '2020-04-26',
      user_id: oguro.id,
      content_id: scheduleContentReWork.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    { # 小黒の予定。別ユーザーとの日程重複のテスト。
      date: '2020-05-31',
      user_id: oguro.id,
      content_id: scheduleContentReHolidayWork.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    { # 小黒の予定。別ユーザーとの詳細共有のテスト。
      date: '2020-05-24',
      user_id: oguro.id,
      content_id: scheduleContentMissReturn.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    { # 山黒の予定。別ユーザーとの詳細共有のテスト。
      date: '2020-05-24',
      user_id: yamaguro.id,
      content_id: scheduleContentMissReturn.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
    { # 山黒の予定。別ユーザーとの日程重複のテスト。
      date: '2020-05-31',
      user_id: yamaguro.id,
      content_id: scheduleContentPoaching.id,
      created_at: DateTime.now,
      updated_at: DateTime.now,
    },
  ]
)