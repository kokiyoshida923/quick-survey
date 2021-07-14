require "rails_helper"

RSpec.describe User, type: :model do
  describe "ユーザー名の存在性を検証" do
    context "ユーザー名が存在する場合" do
      it "ユーザー名が有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "ユーザー名が空文字の場合" do
      it "ユーザー名が無効であること" do
        user = FactoryBot.build(:user, name: "")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("ユーザー名を入力してください")
      end
    end
    context "ユーザー名が空白文字の場合" do
      it "ユーザー名が無効であること" do
        user = FactoryBot.build(:user, name: " ")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("ユーザー名を入力してください")
      end
    end
    context "ユーザー名がnilの場合" do
      it "ユーザー名が無効であること" do
        user = FactoryBot.build(:user, name: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("ユーザー名を入力してください")
      end
    end
  end

  describe "メールアドレスの存在性を検証" do
    context "メールアドレスが存在する場合" do
      it "メールアドレスが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "メールアドレスが空文字の場合" do
      it "メールアドレスが無効であること" do
        user = FactoryBot.build(:user, email: "")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
    context "メールアドレスが空白文字の場合" do
      it "メールアドレスが無効であること" do
        user = FactoryBot.build(:user, email: " ")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
    context "メールアドレスがnilの場合" do
      it "メールアドレスが無効であること" do
        user = FactoryBot.build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("メールアドレスを入力してください")
      end
    end
  end

  describe "パスワードの存在性を検証" do
    context "パスワードが存在する場合" do
      it "パスワードが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "パスワードが空文字の場合" do
      it "パスワードが無効であること" do
        user = FactoryBot.build(:user, password: "")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
    context "パスワードが空白文字の場合" do
      it "パスワードが無効であること" do
        user = FactoryBot.build(:user, password: " ")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
    context "パスワードがnilの場合" do
      it "パスワードが無効であること" do
        user = FactoryBot.build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードを入力してください")
      end
    end
  end

  describe "パスワード(確認用)の存在性を検証" do
    context "パスワード(確認用)が存在する場合" do
      it "パスワード(確認用)が有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "パスワード(確認用)が空文字の場合" do
      it "パスワード(確認用)が無効であること" do
        user = FactoryBot.build(:user, password_confirmation: "")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワード(確認用)を入力してください", "パスワード(確認用)とパスワードの入力が一致しません")
      end
    end
    context "パスワード(確認用)が空白文字の場合" do
      it "パスワード(確認用)が無効であること" do
        user = FactoryBot.build(:user, password_confirmation: " ")
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワード(確認用)を入力してください", "パスワード(確認用)とパスワードの入力が一致しません")
      end
    end
    context "パスワード(確認用)がnilの場合" do
      it "パスワード(確認用)が無効であること" do
        user = FactoryBot.build(:user, password_confirmation: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワード(確認用)を入力してください")
      end
    end
  end

  describe "ユーザー名の長さを検証" do
    context "ユーザー名が6文字以上20文字以下の場合" do
      it "ユーザー名が有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "ユーザー名が5文字以下の場合" do
      it "ユーザー名が無効であること" do
        invalid_name = Faker::Alphanumeric.alpha(number: 5)
        user = FactoryBot.build(:user, name: invalid_name)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("ユーザー名は6文字以上で入力してください")
      end
    end
    context "ユーザー名が21文字以上の場合" do
      it "ユーザー名が無効であること" do
        invalid_name = Faker::Alphanumeric.alpha(number: 21)
        user = FactoryBot.build(:user, name: invalid_name)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("ユーザー名は20文字以内で入力してください")
      end
    end
  end

  describe "メールアドレスの長さを検証" do
    context "メールアドレスが255文字以下の場合" do
      it "メールアドレスが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "メールアドレスが256文字以上の場合" do
      it "メールアドレスが無効であること" do
        invalid_email = "#{Faker::Alphanumeric.alpha(number: 244)}@example.com"
        user = FactoryBot.build(:user, email: invalid_email)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("メールアドレスは255文字以内で入力してください")
      end
    end
  end

  describe "パスワードの長さを検証" do
    context "パスワードが8文字以上32文字以下の場合" do
      it "パスワードが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "パスワードが7文字以下の場合" do
      it "パスワードが無効であること" do
        invalid_password = Faker::Alphanumeric.alpha(number: 7)
        user = FactoryBot.build(:user, password: invalid_password)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードは8文字以上で入力してください")
      end
    end
    context "パスワードが33文字以上の場合" do
      it "パスワードが無効であること" do
        invalid_password = Faker::Alphanumeric.alpha(number: 33)
        user = FactoryBot.build(:user, password: invalid_password)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードは32文字以内で入力してください")
      end
    end
  end

  describe "メールアドレスのフォーマットの検証" do
    context "メールアドレスのフォーマットに準じているとき" do
      it "メールアドレスが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "メールアドレスのフォーマットに準じてないとき" do
      it "メールアドレスが無効であること" do
        valid_address = Faker::Internet.email(name: "user email", separators: ["-"], domain: "example")
        invalid_addresses = [
          valid_address.sub(/\./, ","),
          valid_address.sub(/@/, "_"),
          valid_address.sub(/\.[a-z]+/, "."),
          valid_address.sub(/example/, "exam_ple"),
          valid_address.sub(/example/, "exam+ple"),
          valid_address.sub(/\./, "..")
        ]
        invalid_addresses.each do |invalid_address|
          user = FactoryBot.build(:user, email: invalid_address)
          expect(user).to be_invalid, "#{invalid_address.inspect} should be invalid"
          expect(user.errors.full_messages).to include("メールアドレスは不正な値です")
        end
      end
    end
  end

  describe "パスワードのフォーマットの検証" do
    context "パスワードのフォーマットに準じているとき" do
      it "パスワードが有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "パスワードのフォーマットに準じてないとき" do
      it "パスワードが無効であること" do
        invalid_password = Faker::Internet.password(
          min_length: 8,
          max_length: 32,
          mix_case: true,
          special_characters: true
        )
        user = FactoryBot.build(:user, password: invalid_password)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワードは不正な値です")
      end
    end
  end

  describe "メールアドレスの一意性を検証" do
    it "メールアドレスが一意であること" do
      user = FactoryBot.build(:user)
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to be_invalid
      expect(duplicate_user.errors.full_messages).to include("メールアドレスはすでに存在します")
    end
    it "メールアドレスが小文字でデータベースに格納されること" do
      upcase_email = Faker::Internet.email(name: "user email", separators: ["-"], domain: "example").upcase
      user = FactoryBot.build(:user, email: upcase_email)
      user.save
      expect(user.email).to eq upcase_email.downcase
    end
  end

  describe "パスワードとパスワード(確認用)の同値性を検証" do
    context "パスワードとパスワード(確認用)が同値であるとき" do
      it "パスワード(確認用)が有効であること" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end
    context "パスワードとパスワード(確認用)が同値でないとき" do
      it "パスワード(確認用)が無効であること" do
        invalid_password_confirmation = Faker::Alphanumeric.alpha(number: 9)
        user = FactoryBot.build(:user, password_confirmation: invalid_password_confirmation)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include("パスワード(確認用)とパスワードの入力が一致しません")
      end
    end
  end
end
