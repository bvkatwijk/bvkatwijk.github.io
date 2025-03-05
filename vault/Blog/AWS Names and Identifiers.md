---
aliases: 
tags:
  - aws
  - cdk
  - hash
  - identity
date: 2025-03-05T07:28:32+00:00
lastmod: 2025-03-05T07:43:02+00:00
draft: "true"
---
[AWS CDK] allows you to develop your cloud setup using source code in a language of your choice. Resulting resources will be automatically set up and changed if necessary. While working in a medium-sized CDK project I encountered a few issues where resources could not be replaced by CloudFormation, and this post describes a workaround for this problem.

### AWS CDK


### Identity and Name
AWS CDK distinguishes four different identities for cloud resources:
1. Construct ID
2. Path ID
3. Unique ID
4. Logical ID

#### Construct ID
This is the name of the construct, unique only relative to its parent. This means that if you create multiple instances of the parent, the child construct ids will not clash with each other.

A 

#### Path ID
The Path for a construct is the chain of construct ids from the root to that construct. 

### Update and Replacement
When AWS receives a new configuration

### Generated Names

### Replaceable Custom Names
What we thus would like is to be able to set a custom name