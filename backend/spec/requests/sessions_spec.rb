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
    let!(:headers) { { "Content-Type" => "application/json" } }
    context "パラメータが妥当かつ「ログイン情報を保存する」をチェックする場合" do
      let!(:user) { FactoryBot.create(:user) }
      before do
        @valid_email = unauth_user.email
        @valid_password = unauth_user.password
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: true
        } }.to_json, headers: headers
        expect(response.status).to eq 200
      end
      it "cookieに一時的な暗号化済みのユーザーIDが生成されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: true
        } }.to_json, headers: headers
        expect(session[:user_id].blank?).to be_falsey
      end
      it "cookieに永続的な暗号化済みのユーザーIDと永続的な暗号化済みの記憶トークンが生成されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: true
        } }.to_json, headers: headers
        expect(cookies.permanent.signed[:user_id].blank?).to be_falsey
        expect(cookies.permanent[:remember_token].blank?).to be_falsey
      end
      it "既認証ユーザーのremember_digest属性がランダムな文字列であるトークンのハッシュ値に更新されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: true
        } }.to_json, headers: headers
        auth_user = User.find(user.id)
        expect(auth_user.remember_digest.nil?).to be_falsey
      end
      it "既認証ユーザーがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: true
        } }.to_json, headers: headers
        json = JSON.parse(response.body)
        expect(json["auth_user"]["id"]).to eq(user.id)
      end
    end
    context "パラメータが妥当かつ「ログイン情報を保存する」をチェックしない場合" do
      let!(:user) { FactoryBot.create(:user) }
      before do
        @valid_email = unauth_user.email
        @valid_password = unauth_user.password
      end
      it "ステータスコード200 (ok) が返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: false
        } }.to_json, headers: headers
        expect(response.status).to eq 200
      end
      it "cookieに一時的な暗号化済みのユーザーIDが生成されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: false
        } }.to_json, headers: headers
        expect(session[:user_id].blank?).to be_falsey
      end
      it "cookieに永続的な暗号化済みのユーザーIDと永続的な暗号化済みの記憶トークンが生成されないこと" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: false
        } }.to_json, headers: headers
        expect(cookies.permanent.signed[:user_id].blank?).to be_truthy
        expect(cookies.permanent[:remember_token].blank?).to be_truthy
      end
      it "既認証ユーザーのremember_digest属性がランダムな文字列であるトークンのハッシュ値に更新されないこと" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: false
        } }.to_json, headers: headers
        auth_user = User.find(user.id)
        expect(auth_user.remember_digest.nil?).to be_truthy
      end
      it "既認証ユーザーがJSON形式で返されること" do
        post "/api/v1/login", params: { session: {
          email: @valid_email,
          password: @valid_password,
          remember_me: false
        } }.to_json, headers: headers
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
    let!(:headers) { { "Content-Type" => "application/json" } }
    context "「ログイン情報を保存する」にチェックしてログインした既認証ユーザーがログアウトした場合" do
      it "ステータスコード204 (no content) が返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: true
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(response.status).to eq 204
      end
      it "cookieに格納されている一時的な暗号化済みのユーザーIDが削除されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: true
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(session[:user_id].blank?).to be_truthy
      end
      it "cookieに永続的な暗号化済みのユーザーIDと永続的な暗号化済みの記憶トークンが削除されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: true
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(cookies.permanent.signed[:user_id].blank?).to be_truthy
        expect(cookies.permanent[:remember_token].blank?).to be_truthy
      end
      it "既認証ユーザーのremember_digest属性がnilに更新されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: true
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        unauth_user = User.find(user.id)
        expect(unauth_user.remember_digest.nil?).to be_truthy
      end
      it "ユーザーがログイン中の場合にのみログアウトできること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: true
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(session[:user_id].blank?).to be_truthy
        delete "/api/v1/logout"
        expect(response.status).to eq 204
      end
    end
    context "「ログイン情報を保存する」にチェックせずにログインした既認証ユーザーがログアウトした場合" do
      it "ステータスコード204 (no content) が返されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: false
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(response.status).to eq 204
      end
      it "cookieに格納されている一時的な暗号化済みのユーザーIDが削除されること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: false
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(session[:user_id].blank?).to be_truthy
      end
      it "ユーザーがログイン中の場合にのみログアウトできること" do
        post "/api/v1/login", params: { session: {
          email: user.email,
          password: user.password,
          remember_me: false
        } }.to_json, headers: headers
        delete "/api/v1/logout"
        expect(session[:user_id].blank?).to be_truthy
        delete "/api/v1/logout"
        expect(response.status).to eq 204
      end
    end
  end
end
