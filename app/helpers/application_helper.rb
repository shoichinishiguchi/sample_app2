module ApplicationHelper
  # ページごとの完全なタイトルを返します。  #コメント業
  def full_title(page_title = '')  #メソッド定義とオプション因数
    base_title = "Ruby on Rails Tutorial Sample App" # 変数への代入
    return base_title if page_title.empty?  # タイトルがなければそのまま
    return page_title + " | " + base_title #タイトルがあればタイトルをつける。
  end
end
