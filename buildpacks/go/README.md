# Go Buildpack

Compatible apps:
- Go apps that use go-mod-vendor, configure arch.txt in the app root directory and specify the arch, eg:arm64.

### Usage

```bash
pack build go-go-mod-vendor-project --builder drycc/buildpacks:20
```