#!/bin/bash

# 使用protoc生成Go接口文件的脚本
# 基于proto文件自动生成Go代码

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查protoc是否安装
if ! command -v protoc &> /dev/null; then
    echo -e "${RED}❌ 错误: protoc 未安装${NC}"
    echo -e "${YELLOW}请先安装 protoc:${NC}"
    echo -e "${BLUE}macOS: brew install protobuf${NC}"
    echo -e "${BLUE}Ubuntu/Debian: sudo apt-get install protobuf-compiler${NC}"
    echo -e "${BLUE}CentOS/RHEL: sudo yum install protobuf-compiler${NC}"
    exit 1
fi

# 检查Go protoc插件是否安装
if ! command -v protoc-gen-go &> /dev/null; then
    echo -e "${RED}❌ 错误: protoc-gen-go 插件未安装${NC}"
    echo -e "${YELLOW}请先安装 Go protoc 插件:${NC}"
    echo -e "${BLUE}go install google.golang.org/protobuf/cmd/protoc-gen-go@latest${NC}"
    echo -e "${BLUE}go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest${NC}"
    exit 1
fi

# 检查Go gRPC插件是否安装
if ! command -v protoc-gen-go-grpc &> /dev/null; then
    echo -e "${RED}❌ 错误: protoc-gen-go-grpc 插件未安装${NC}"
    echo -e "${YELLOW}请先安装 Go gRPC 插件:${NC}"
    echo -e "${BLUE}go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest${NC}"
    exit 1
fi

# 输出目录
GO_OUTPUT_DIR="pkg/"
PROTO_FILE="proto/service_manager.proto"

echo -e "${BLUE}🕛 开始使用 protoc 生成Go接口文件...${NC}"

# 创建输出目录
mkdir -p "${GO_OUTPUT_DIR}"

# 使用protoc生成Go代码
echo -e "${YELLOW}📝 正在生成Go代码...${NC}"
protoc \
    --proto_path=proto \
    --go_out="${GO_OUTPUT_DIR}" \
    --go_opt=paths=source_relative \
    --go-grpc_out="${GO_OUTPUT_DIR}" \
    --go-grpc_opt=paths=source_relative \
    "${PROTO_FILE}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Go代码生成成功！${NC}"
else
    echo -e "${RED}❌ Go代码生成失败！${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Go接口文件生成完成！${NC}"
echo -e "${YELLOW}📁 输出目录: ${GO_OUTPUT_DIR}${NC}"
echo -e "${BLUE}📋 生成的文件:${NC}"
ls -la "${GO_OUTPUT_DIR}"

echo -e "\n${GREEN}🎉 脚本执行完成！${NC}"
echo -e "${YELLOW}💡 提示: 现在你可以使用生成的gRPC代码了${NC}"
