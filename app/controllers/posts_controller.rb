class PostsController < ApplicationController
  before_action :authenticate_user!  #  JWT authentication
  
  #get the id of the posts before applying actions.
  before_action :set_post, only: [:show, :update, :destroy, :update_tags]
  #this to make sure that the authorized user only can update or delete their own posts
  before_action :authorize_user!, only: [:update, :destroy]


  def create
    post = current_user.posts.build(post_params)  # Associate post with the logged-in user
    
    if post.save
      render json: { message: 'Post created successfully', post: post }, status: :created
    else
      render json: { error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def index
    posts = Post.all
    render json: posts, status: :ok
  end
  def show
    render json: @post, status: :ok
  end

#if the tags are edited only by the author 

=begin
  def update
    if @post.update(post_params)
      render json: { message: 'Post updated successfully', post: @post }, status: :ok
    else
      render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
=end 

# if the tags are updated by any user while the other field of the post are edited by the authorized user
  def update
    if @post.user_id == current_user.id
      if @post.update(post_params)
        render json: { message: 'Post updated successfully', post: @post }
      else
        render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized to update this post' }, status: :forbidden
    end
  end
  
  def update_tags
    if @post.update(tags_params)
      render json: { message: 'Post tags updated successfully', post: @post }
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end




  def destroy
    @post.destroy
    render json: { message: 'Post deleted successfully' }, status: :no_content
  end


  private


  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end


  def authorize_user!
    unless @post.user_id == current_user.id
      render json: { error: 'Not authorized' }, status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :tags)  # Allow other fields as necessary
  end

  def tags_params
    params.require(:post).permit(:tags)  # Only allow tags to be updated
  end
end
