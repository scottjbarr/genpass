#Grab the latest alpine image
FROM alpine:latest

# Add our code
ADD ./dist/genpass-http /app/
WORKDIR /app

# Expose is NOT supported by Heroku
# EXPOSE 5000

# Run the image as a non-root user
RUN adduser -D app
USER app

ENV BIND=:$PORT

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku
CMD ["/app/genpass-http"]
