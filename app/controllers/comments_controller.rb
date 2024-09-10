class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_post
    before_action :find_comment, only: [:update, :destroy]
  
    def create
      comment = @post.comments.build(comment_params.merge(user_id: current_user.id))
      
      if comment.save
        render json: { message: 'Comment created successfully', comment: comment }, status: :created
      else
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @comment.user_id == current_user.id
        if @comment.update(comment_params)
          render json: { message: 'Comment updated successfully', comment: @comment }
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Not authorized to update this comment' }, status: :forbidden
      end
    end
  
    def destroy
      if @comment.user_id == current_user.id
        @comment.destroy
        render json: { message: 'Comment deleted successfully' }, status: :no_content
      else
        render json: { error: 'Not authorized to delete this comment' }, status: :forbidden
      end
    end
  
    private
  
    def find_post
      @post = Post.find(params[:post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Post not found' }, status: :not_found
    end
  
    def find_comment
      @comment = @post.comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Comment not found' }, status: :not_found
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  end
  