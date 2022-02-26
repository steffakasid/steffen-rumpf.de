# steffen-rumpf.de

## Introduction

This project defines my webpage as link:gohugo.io[gohugo] project. I decided to use asciidoc because of the most flexibility in formatting.

Previously this page was build using the maven-site plugin with a custom maven plugin written by myself which allowed to create a blog. But as found out that hugo is much more powerful I decided to switch. Also I publish now with Ionos deploy-now which supports hugo out-of-the-box.

## How to hightlight code in blog posts

```
{{< highlight go "linenos=true" >}}
...
{{< / highlight >}}
```

## How to create GitHub projects page

In order to list all my GitHub projects. I used the following command to retreive all public projects from GitHub and strip out only a few fields using yq:

[source,sh]
----
curl https://api.github.com/users/steffakasid/repos | yq '.[] | [{"name": .name, "description": .description, "url": .svn_url}]'
----
## Further reading

- https://gohugo.io
- https://www.ionos.de/hosting/deploy-now
- https://asciidoctor.org/