require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "'/login'にGETメソッドでリクエストを送信した場合" do
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

  describe "'/login'にPOSTメソッドでリクエストを送信した場合" do
    context "パラメータが妥当な場合" do
      let!(:user) { FactoryBot.create(:user) }
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        expect(response.status).to eq 200
      end
      it "cookieに一時的な暗号化済みのユーザーIDが生成されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        expect(session[:user_id].nil?).to be_falsey
      end
      it "認証されたユーザーがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password
        } }
        json = JSON.parse(response.body)
        expect(json["auth_user"]["id"]).to eq(user.id)
      end
    end
    context "パラメータが不当な場合" do
      let!(:user) { FactoryBot.create(:user) }
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email.sub(/@/, "_"),
          password: user.password.chop
        } }
        expect(response.status).to eq 200
      end
      it "エラーメッセージがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email.sub(/@/, "_"),
          password: user.password.chop
        } }
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_truthy
      end
    end
  end
end
