class PrototypesController < ApplicationController
  before_action :authenticate_user!, except:[:new,:edit,:delete,:update]
  
  def index
    @prototypes = Prototype.includes(:user) #全てのプロトタイプテーブル取得
  end
  
  def new
    @prototype = Prototype.new
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new #comment生成
    @comments = @prototype.comments.includes(:user) #prototypeの中にuser情報も入れる
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      redirect_to root_path
    end
  end

  def destroy
     prototype = Prototype.find(params[:id])
     prototype.destroy
     redirect_to root_path #消去完了後ホーム画面に戻る
  end

  def update
    @prototype = Prototype.find(params[:id])
   if @prototype.update(create_params) #create_parameで取得したidを更新
    redirect_to prototype_path #詳細画面に戻る
   else
    render :edit  #更新できない場合、編集ページに戻る
   end
  end

  def create
    @prototype = Prototype.new(create_params) #@prototypeのインスタンス変数にcreate_paramsを生成
   if @prototype.save #生成した@prototypeを保存
    redirect_to root_path(@prototype) #保存した場合、root_pathへ
   else
    @prototype = @prototype.includes(:user)
    render :new #保存できない場合newの表示
   end
  end
  
  private
  def create_params
    params.require(:prototype).permit( :title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end
