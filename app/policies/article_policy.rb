class ArticlePolicy < ApplicationPolicy
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end

  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && user == article.user
  end

  def destroy?
    update?
  end

  def show?
    true
  end
end
