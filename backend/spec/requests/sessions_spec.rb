require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "'/verification'にGETメソッドでリクエストを送信" do
    context "ユーザーがログインしていない場合" do
      it "ステータスコード200 (ok) が返されること" do
        get "/api/v1/verification"
        expect(response.status).to eq 200
      end
      it "未認証状態を表す論理値がJSON形式で返されること" do
        get "/api/v1/verification"
        json = JSON.parse(response.body)
        expect(json["is_authenticated"]).to eq false
      end
    end
    context "ユーザーがログインしている場合" do
      let!(:user) { FactoryBot.create(:user) }
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        get "/api/v1/verification"
        expect(response.status).to eq 200
      end
      it "既認証状態を表す論理値がJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        get "/api/v1/verification"
        json = JSON.parse(response.body)
        expect(json["is_authenticated"]).to eq true
      end
      it "既認証ユーザーがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        get "/api/v1/verification"
        json = JSON.parse(response.body)
        expect(json["auth_user"]["id"]).to eq(user.id)
      end
    end
  end

  describe "'/login'にGETメソッドでリクエストを送信" do
    it "ステータスコード200 (ok) が返されること" do
      get "/api/v1/login"
      expect(response.status).to eq 200
    end
    it "未認証ユーザーがJSON形式で返されること" do
      get "/api/v1/login"
      json = JSON.parse(response.body)
      expect(json["unauth_user"]["email"].nil?).to be_truthy
      expect(json["unauth_user"]["password"].nil?).to be_truthy
    end
  end

  describe "'/login'にPOSTメソッドでリクエストを送信" do
    let!(:unauth_user) { FactoryBot.build(:unauth_user) }
    context "パラメータが妥当な場合" do
      let!(:user) { FactoryBot.create(:user) }
      before do
        @valid_email = unauth_user.email
        @valid_password = unauth_user.password
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password
        } }
        expect(response.status).to eq 200
      end
      it "cookieに一時的な暗号化済みのユーザーIDが生成されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password
        } }
        expect(session[:user_id].nil?).to be_falsey
      end
      it "既認証ユーザーがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password
        } }
        json = JSON.parse(response.body)
        expect(json["auth_user"]["id"]).to eq(user.id)
      end
    end
    context "パラメータが不当な場合" do
      before do
        @invalid_email = unauth_user.email.sub(/@/, "_")
        @invalid_password = unauth_user.password.chop
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: @invalid_email,
          password: @invalid_password
        } }
        expect(response.status).to eq 200
      end
      it "エラーメッセージがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: @invalid_email,
          password: @invalid_password
        } }
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_truthy
      end
    end
  end

  describe "'/logout'にDELETEメソッドでリクエストを送信" do
    let!(:user) { FactoryBot.create(:user) }
    it "ステータスコード204 (no content) が返されること" do
      post "/api/v1/login", params: { session: {
        email: user.email,
        password: user.password
      } }
      delete "/api/v1/logout"
      expect(response.status).to eq 204
    end
    it "cookieに格納されている一時的な暗号化済みのユーザーIDが削除されること" do
      post "/api/v1/login", params: { session: {
        email: user.email,
        password: user.password
      } }
      delete "/api/v1/logout"
      expect(session[:user_id].blank?).to be_truthy
    end
    it "ユーザーがログイン中の場合にのみログアウトできること" do
      post "/api/v1/login", params: { session: {
        email: user.email,
        password: user.password
      } }
      delete "/api/v1/logout"
      expect(session[:user_id].blank?).to be_truthy
      delete "/api/v1/logout"
      expect(response.status).to eq 204
    end
  end
end
