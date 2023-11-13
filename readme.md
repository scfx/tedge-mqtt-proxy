# Thin-edge.io mqtt proxy

This plugin is a http proxy for the thin-edge mqtt broker. If you control does not support mqtt, or you want to use REST for any other reason, this plugin is for you. It maps all REST POST Messages with the URL '/tedge/\_', '/te/\_', '/c8y/\_' to the mqtt topic and forwards the request body.

---

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.

## Prerequisites

- thin-edge v 0.13
- system d for dpkg packages

## Demo/Tests

Thin-edge and the proxy can be used locally with docker running the following commands:

```bash
just up
```

## Build

You can build dpkg packages for your architecture with the following command:

```bash
./package.sh --version {{version}} --arch {{architecture}}
```
