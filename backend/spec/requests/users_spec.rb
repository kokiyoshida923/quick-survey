require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "'/users/:id'にGETメソッドでリクエストを送信" do
    let!(:user) { FactoryBot.create(:user) }
    it "ステータスコード200 (ok) が返されること" do
      get "/api/v1/users/#{user.id}"
      expect(response.status).to eq 200
    end
    it "ルーティングのパラメータに対応するユーザーがJSON形式で返されること" do
      get "/api/v1/users/#{user.id}"
      json = JSON.parse(response.body)
      expect(json["user"]["id"]).to eq(user.id)
    end
  end

  describe "'/signup'にGETメソッドでリクエストを送信" do
    it "ステータスコード200 (ok) が返されること" do
      get "/api/v1/signup"
      expect(response.status).to eq 200
    end
    it "未登録ユーザーがJSON形式で返されること" do
      get "/api/v1/signup"
      json = JSON.parse(response.body)
      expect(json["user"]["id"]).to eq(nil)
    end
  end

  describe "'/signup'にPOSTメソッドでリクエストを送信" do
    context "パラメータが妥当な場合" do
      before do
        @valid_name = Faker::Internet.username(specifier: 6..20, separators: %w[. _ -])
        @valid_email = Faker::Internet.email(domain: "valid")
        @valid_password = Faker::Internet.password(
          min_length: 8,
          max_length: 32,
          mix_case: true,
          special_characters: false
        )
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/signup", params: { user: {
          name: @valid_name,
          email: @valid_email,
          password: @valid_password,
          password_confirmation: @valid_password
        } }
        expect(response.status).to eq 200
      end
      it "既登録ユーザーがJSON形式で返されること" do
        post "/api/v1/signup", params: { user: {
          name: @valid_name,
          email: @valid_email,
          password: @valid_password,
          password_confirmation: @valid_password
        } }
        json = JSON.parse(response.body)
        expect(json["user"]["id"]).to eq(User.last.id)
      end
      it "Userモデルが1増加されること" do
        expect {
          post "/api/v1/signup", params: { user: {
            name: @valid_name,
            email: @valid_email,
            password: @valid_password,
            password_confirmation: @valid_password
          } }
        }.to change(User, :count).by(1)
      end
    end
    context "パラメータが不当な場合" do
      before do
        @invalid_name = Faker::Internet.username(specifier: [(1..5), 21].sample)
        @invalid_email = Faker::Internet.email(domain: "invalid").gsub("@", "")
        @invalid_password = [
          Faker::Alphanumeric.alpha(number: 7),
          Faker::Alphanumeric.alpha(number: 33)
        ].sample
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/signup", params: { user: {
          name: @invalid_name,
          email: @invalid_email,
          password: @invalid_password,
          password_confirmation: @invalid_password
        } }
        expect(response.status).to eq 200
      end
      it "エラーメッセージがJSON形式で返されること" do
        post "/api/v1/signup", params: { user: {
          name: @invalid_name,
          email: @invalid_email,
          password: @invalid_password,
          password_confirmation: @invalid_password
        } }
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_truthy
      end
      it "Userモデルが増減しないこと" do
        expect {
          post "/api/v1/signup", params: { user: {
            name: @invalid_name,
            email: @invalid_email,
            password: @invalid_password,
            password_confirmation: @invalid_password
          } }
        }.to_not change(User, :count)
      end
    end
  end
end
