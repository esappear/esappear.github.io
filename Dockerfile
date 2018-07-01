# The FROM instruction sets the Base Image for subsequent instructions.
# Using Nginx as Base Image
FROM daocloud.io/node:8.4.0
MAINTAINER Shawn <624835942@qq.com>

COPY . /blog

WORKDIR /blog

# The RUN instruction will execute any commands
# Adding HelloWorld page into Nginx server
RUN npm install -g hexo --registry=https://registry.npm.taobao.org \
  && npm install --registry=https://registry.npm.taobao.org

# The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime
EXPOSE 4000

# The CMD instruction provides default execution command for an container
# Start Nginx and keep it from running background
CMD hexo server
