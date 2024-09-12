FROM ruby:3.1.2

# Set up the working directory
WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Expose port
EXPOSE 3000
