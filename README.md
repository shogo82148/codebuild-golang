# codebuild-golang
Golang Docker Image for CodeBuild

## Purpose

It is a CodeBuild custom image including Golang runtime, based on [AWS CodeBuild curated Docker images](https://github.com/aws/aws-codebuild-docker-images).
This image is optimized to Golang project.

## Usage

Pre-built images are available on DockerHub.

- [shogo82148/codebuild-golang](https://hub.docker.com/r/shogo82148/codebuild-golang)

Docker Pull Command:

```bash
# standard 5.0 based
docker pull shogo82148/codebuild-golang:1.18-standard-5.0
docker pull shogo82148/codebuild-golang:1.17-standard-5.0
docker pull shogo82148/codebuild-golang:1.16-standard-5.0
docker pull shogo82148/codebuild-golang:1.15-standard-5.0

# standard 4.0 based
docker pull shogo82148/codebuild-golang:1.18-standard-4.0
docker pull shogo82148/codebuild-golang:1.17-standard-4.0
docker pull shogo82148/codebuild-golang:1.16-standard-4.0
docker pull shogo82148/codebuild-golang:1.15-standard-4.0

# standard 3.0 based
docker pull shogo82148/codebuild-golang:1.18-standard-3.0
docker pull shogo82148/codebuild-golang:1.17-standard-3.0
docker pull shogo82148/codebuild-golang:1.16-standard-3.0
docker pull shogo82148/codebuild-golang:1.15-standard-3.0

# amazonlinux2-x86_64-standard 3.0 based
docker pull shogo82148/codebuild-golang:1.18-amazonlinux2-3.0
docker pull shogo82148/codebuild-golang:1.17-amazonlinux2-3.0
docker pull shogo82148/codebuild-golang:1.16-amazonlinux2-3.0
docker pull shogo82148/codebuild-golang:1.15-amazonlinux2-3.0

# amazonlinux2-x86_64-standard 2.0 based
docker pull shogo82148/codebuild-golang:1.18-amazonlinux2-2.0
docker pull shogo82148/codebuild-golang:1.17-amazonlinux2-2.0
docker pull shogo82148/codebuild-golang:1.16-amazonlinux2-2.0
docker pull shogo82148/codebuild-golang:1.15-amazonlinux2-2.0
```

### An Example of CloudFormation Template for Creating CodeBuild Project

```yaml
  CodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Artifacts:
        Type: NO_ARTIFACTS
      Environment:
        ComputeType: BUILD_GENERAL1_SMALL
        Image: shogo82148/codebuild-golang:1.18-standard-5.0
        Type: LINUX_CONTAINER
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Source:
        Type: GITHUB
        ReportBuildStatus: true
        Location: https://github.com/shogo82148/codebuild-golang
      TimeoutInMinutes: 10
  CodeBuildRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: codebuild.amazonaws.com
            Action: "sts:AssumeRole"
      Path: "/"
      Policies:
        - PolicyDocument:
            Statement:
              - Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                  - logs:DescribeLogStreams
                Effect: Allow
                Resource: arn:aws:logs:*:*:*
            Version: 2012-10-17
          PolicyName: cloudWatchLogsPolicy
```

## RELATED WORK

- https://github.com/aws/aws-codebuild-docker-images
