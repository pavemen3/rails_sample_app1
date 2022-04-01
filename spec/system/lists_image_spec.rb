# frozen_string_literal: true

require 'rails_helper'

describe '画像投稿のテスト' do
  let!(:list) { create(:list, title:'hoge',body:'body') }

  describe '投稿画面のテスト' do
    before do
      visit new_list_path
    end
    context '表示の確認' do
      it 'new_list_pathが"/lists/new"であるか' do
        expect(current_path).to eq('/lists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end

    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        attach_file 'list[image]', "#{Rails.root}/spec/fixtures/images/temple.jpg"
        click_button '投稿'
        expect(page).to have_current_path list_path(List.last)
      end
    end
  end

  describe '一覧画面と詳細画面のテスト' do
    before do
      visit new_list_path
      fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
      fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
      attach_file 'list[image]', "#{Rails.root}/spec/fixtures/images/temple.jpg"
      click_button '投稿'
    end

    context '一覧の表示' do
      it '一覧表示画面に投稿された画像が表示されているか' do
        visit lists_path
        expect(page).to have_selector("img[src$='temple.jpg']")
      end
    end
    context '詳細画面の表示' do
      it '詳細画面に投稿された画像が表示されているか' do
        expect(page).to have_selector("img[src$='temple.jpg']")
      end
    end
  end
end