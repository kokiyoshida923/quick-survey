require "rails_helper"

RSpec.describe Session, type: :model do
  describe "メールアドレスの存在性を検証" do
    context "メールアドレスが存在する場合" do
      let!(:user) { FactoryBot.create(:user) }
      it "メールアドレスが有効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user)
        expect(unauthenticated_user).to be_valid
      end
    end
    context "メールアドレスが空文字の場合" do
      it "メールアドレスが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, email: "")
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
    context "メールアドレスが空白文字の場合" do
      it "メールアドレスが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, email: " ")
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
    context "メールアドレスがnilの場合" do
      it "メールアドレスが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, email: nil)
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
  end

  describe "パスワードの存在性を検索" do
    context "パスワードが存在する場合" do
      let!(:user) { FactoryBot.create(:user) }
      it "パスワードが有効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user)
        expect(unauthenticated_user).to be_valid
      end
    end
    context "パスワードが空文字の場合" do
      it "パスワードが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, password: "")
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
    context "パスワードが空白文字の場合" do
      it "パスワードが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, password: " ")
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
    context "パスワードがnilの場合" do
      it "パスワードが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, password: nil)
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
  end

  describe "メールアドレスの照合性を検証" do
    let!(:user) { FactoryBot.create(:user) }
    context "メールアドレスがusersテーブルの任意のレコードと照合するとき" do
      it "メールアドレスが有効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user)
        expect(unauthenticated_user).to be_valid
      end
    end
    context "メールアドレスがusersテーブルの任意のレコードと照合しないとき" do
      it "メールアドレスが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, email: user.email.sub(/@/, "_"))
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("メールアドレスは正しくありません")
      end
    end
  end

  describe "パスワードの照合性を検証" do
    let!(:user) { FactoryBot.create(:user) }
    context "メールアドレスがusersテーブルの任意のレコードと照合するかつ、パスワードがそのレコードの暗号化されたパスワードと照合するとき" do
      it "パスワードが有効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user)
        expect(unauthenticated_user).to be_valid
      end
    end
    context "メールアドレスがusersテーブルの任意のレコードと照合しないとき" do
      it "パスワードが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, email: user.email.sub(/@/, "_"))
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("パスワードは正しくありません")
      end
    end
    context "メールアドレスがusersテーブルの任意のレコードと照合するかつ、パスワードがそのレコードの暗号化されたパスワードと照合しないとき" do
      it "パスワードが無効であること" do
        unauthenticated_user = FactoryBot.build(:unauthenticated_user, password: user.password.chop)
        expect(unauthenticated_user).to be_invalid
        expect(unauthenticated_user.errors.full_messages).to include("パスワードは正しくありません")
      end
    end
  end
end
