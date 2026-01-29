require "test_helper"

class Content::PersonTest < ActiveSupport::TestCase
  test "find でスラッグから人物を取得できる" do
    person = Content::Person.find("oda-nobunaga")
    assert_equal "織田信長", person.title
  end

  test "存在しないスラッグで ResourceNotFoundError が発生する" do
    assert_raises(Perron::Errors::ResourceNotFoundError) do
      Content::Person.find("nonexistent")
    end
  end

  test "title が frontmatter の値を返す" do
    person = Content::Person.find("akechi-mitsuhide")
    assert_equal "明智光秀", person.title
  end

  test "era が frontmatter の値を返す" do
    person = Content::Person.find("akechi-mitsuhide")
    assert_equal "戦国", person.era
  end

  test "related が配列で返る（複数の場合）" do
    person = Content::Person.find("oda-nobunaga")
    assert_equal [ "akechi-mitsuhide", "toyotomi-hideyoshi" ], person.related
  end

  test "related が配列で返る（単一の場合）" do
    person = Content::Person.find("akechi-mitsuhide")
    assert_equal [ "oda-nobunaga" ], person.related
  end

  test "all が全人物を返す" do
    people = Content::Person.all
    assert_equal 3, people.size
    titles = people.map(&:title)
    assert_includes titles, "織田信長"
    assert_includes titles, "明智光秀"
    assert_includes titles, "豊臣秀吉"
  end

  test "content が本文を返す" do
    person = Content::Person.find("oda-nobunaga")
    assert_includes person.content, "織田信長は"
  end

  test "slug がファイル名から導出される" do
    person = Content::Person.find("oda-nobunaga")
    assert_equal "oda-nobunaga", person.slug
  end
end
