# 行内の何番目が何の値なのかを返すクラス
class SpreadsheetsData
  def initialize(row)
    @row = row
  end

  # 生徒名
  def student_name
    @row[0]
  end

  # 性別
  def gender
    @row[1]
  end

  # 学年
  def class_level
    @row[2]
  end

  # 出身州
  def home_state
    @row[3]
  end

  # 専攻
  def major
    @row[4]
  end

  # 課外活動
  def extracurricular_activity
    @row[5]
  end
end

class SpreadsheetsImportJob < ApplicationJob
  queue_as :default

  def perform(spreadsheet_id, range)
    gs = Google::Spreadsheets.new
    
    res = gs.get_values(spreadsheet_id, range)
    return if res.values.empty? # 値が空だった場合はここで終了

    res.values.drop(1).each do |row| # 1行目はヘッダーなので削除
      s_data = SpreadsheetsData.new(row)
      
      # それぞれの値をマッピング
      student_name = s_data.student_name
      gender = s_data.gender
      class_level = s_data.class_level
      home_state = s_data.home_state
      major = s_data.major
      extracurricular_activity = s_data.extracurricular_activity

      # 重複するデータを作成したくないのでfind_or_initialize_byを使用
      user = User.find_or_initialize_by(
        student_name: student_name,
        gender: gender,
        class_level: class_level,
        home_state: home_state,
        major: major,
        extracurricular_activity: extracurricular_activity
      )

      user.save
    end
  end
end
