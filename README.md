# steffen-rumpf.de

## Introduction

This project defines my webpage as maven-site project. I decided to use asciidoc because of the most flexibility in formatting (see pom.xml file how asciidoc can be used within maven-site).  Additionally this project uses a maven plugin I've creaetd in order to be able to have multiple 'blog post files' which are included into the side.

## Usage

- To build the site run the:

    ```sh
    mvn clean generate-sources pre-site site:site
    ```

- To deploy the site to the remote server using `<distributionManagement>` run:

    ```sh
    mvn clean generate-sources pre-site site:site site:deploy
    ```
    **Note:** The distributionManagement in the pom.xml uses key based authentication. Therefore I don't have to give a password here.

## Licence information

This project uses highlight js default.min.css which is under licence by:

```text
Copyright (c) 2006, Ivan Sagalaev
All rights reserved.
```

See the included licence file under `src/site/resources/css`

## Get all GitHub Projects

curl https://api.github.com/users/steffakasid/repos | yq '.[] | [{"name": .name, "description": .description, "url": .svn_url}]'

## Further reading

- https://maven.apache.org/plugins/maven-site-plugin/usage.html
- https://asciidoctor.org/