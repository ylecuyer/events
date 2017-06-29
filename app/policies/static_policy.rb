class StaticPolicy < Struct.new(:user, :static)

  def show?
    true
  end

  def show_configuration?
    user.has_role? :admin
  end

end
