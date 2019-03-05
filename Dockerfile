# 安装maven
FROM maven:3.3.9-jdk-8

#设置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# china mirrors
ADD sources.list /etc/apt/sources.list
ADD settings.xml /usr/share/maven/ref/

RUN \
  apt-get update \

  # 安装 FFmpeg (source code make)
  && apt-get install -y yasm pkg-config make gcc \
  # && curl -fSL "https://codeload.github.com/FFmpeg/FFmpeg/zip/master" -o FFmpeg.zip \
  && curl http://o8svz33ym.bkt.clouddn.com/FFmpeg.zip -o FFmpeg.zip && unzip FFmpeg.zip \
  && cd FFmpeg && ./configure && make && make install \
  && cd ../ && rm -rf FFmpeg FFmpeg.zip \

  # 安装微软雅黑字体
  && curl -O http://o8svz33ym.bkt.clouddn.com/msyh.ttf \
  && cp msyh.ttf /usr/share/fonts/truetype/msyh.ttf \
  && fc-cache -fv \

  # clear
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

# 拷贝部署脚本到镜像
ADD build.sh /tmp/

# 允许挂载 Tomcat 日志目录
VOLUME /usr/local/tomcat/logs

# 允许挂载源码目录
VOLUME /tmp/code

EXPOSE 8080
