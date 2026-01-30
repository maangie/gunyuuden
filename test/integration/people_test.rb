require "test_helper"

class PeopleTest < ActionDispatch::IntegrationTest
  #: () -> void
  setup do
    @modern_ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  end

  test "ルートパスで明智光秀のページが表示される" do
    get root_path, headers: { "User-Agent" => @modern_ua }
    assert_response :success
    assert_select "h1", text: "明智光秀"
  end

  test "ルートパスの title タグが「明智光秀 — 群雄伝」" do
    get root_path, headers: { "User-Agent" => @modern_ua }
    assert_select "title", text: "明智光秀 — 群雄伝"
  end

  test "show ページで人物名が h1 に表示される" do
    get person_path("oda-nobunaga"), headers: { "User-Agent" => @modern_ua }
    assert_response :success
    assert_select "h1", text: "織田信長"
  end

  test "show ページで Markdown が HTML に変換されている" do
    get person_path("oda-nobunaga"), headers: { "User-Agent" => @modern_ua }
    assert_select "article.prose" do
      assert_select "a[href]"
    end
  end

  test "show ページで関連項目が日本語タイトル付きリンクで表示される" do
    get person_path("oda-nobunaga"), headers: { "User-Agent" => @modern_ua }
    assert_select "article.prose" do
      assert_select "h2", text: "関連項目"
      assert_select "a[href=?]", person_path("akechi-mitsuhide"), text: "明智光秀"
      assert_select "a[href=?]", person_path("toyotomi-hideyoshi"), text: "豊臣秀吉"
    end
  end

  test "show ページで単一の関連項目も正しく表示される" do
    get person_path("akechi-mitsuhide"), headers: { "User-Agent" => @modern_ua }
    assert_select "article.prose" do
      assert_select "h2", text: "関連項目"
      assert_select "a[href=?]", person_path("oda-nobunaga"), text: "織田信長"
    end
  end

  test "存在しない人物で例外が発生する" do
    assert_raises(Perron::Errors::ResourceNotFoundError) do
      get person_path("nonexistent"), headers: { "User-Agent" => @modern_ua }
    end
  end

  test "show ページの title タグにサイト名が含まれる" do
    get person_path("oda-nobunaga"), headers: { "User-Agent" => @modern_ua }
    assert_select "title", text: /群雄伝/
  end

  test "index ページで全人物が一覧表示される" do
    get people_path, headers: { "User-Agent" => @modern_ua }
    assert_response :success
    assert_select "h1", text: "人物一覧"
    assert_select "li", count: 3
  end

  test "index ページで各人物へのリンクがある" do
    get people_path, headers: { "User-Agent" => @modern_ua }
    assert_select "a[href=?]", person_path("oda-nobunaga"), text: "織田信長"
    assert_select "a[href=?]", person_path("akechi-mitsuhide"), text: "明智光秀"
    assert_select "a[href=?]", person_path("toyotomi-hideyoshi"), text: "豊臣秀吉"
  end

  test "レイアウトのヘッダーに「群雄伝」リンクがある" do
    get root_path, headers: { "User-Agent" => @modern_ua }
    assert_select "header" do
      assert_select "a[href=?]", root_path, text: "群雄伝"
    end
  end
end
