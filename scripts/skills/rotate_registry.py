import json
import urllib.request

import docker


class RegistryRotation:
    def __init__(self, base="http://disglair.local:3003", name="skills", keep=5):
        self.base = base
        self.name = name
        self.keep = keep
        self.accept = ", ".join(
            [
                "application/vnd.docker.distribution.manifest.v2+json",
                "application/vnd.oci.image.manifest.v1+json",
                "application/vnd.oci.image.index.v1+json",
            ]
        )

    def run(self):
        self._delete_old()
        self._collect()

    def _call(self, method, path, headers=None):
        request = urllib.request.Request(
            f"{self.base}{path}",
            method=method,
            headers=headers or {},
        )
        with urllib.request.urlopen(request) as response:
            return dict(response.headers), response.read()

    def _digest(self, headers):
        for key, value in headers.items():
            if key.lower() == "docker-content-digest":
                return value
        return None

    def _tags(self):
        _, body = self._call("GET", f"/v2/{self.name}/tags/list")
        names = [tag for tag in (json.loads(body).get("tags") or []) if tag != "latest"]
        images = []
        for tag in names:
            headers, body = self._call(
                "GET",
                f"/v2/{self.name}/manifests/{tag}",
                {"Accept": self.accept},
            )
            manifest = json.loads(body)
            if "manifests" in manifest:
                created = ""
            else:
                config = manifest["config"]["digest"]
                _, config_body = self._call("GET", f"/v2/{self.name}/blobs/{config}")
                created = json.loads(config_body).get("created", "")
            images.append((created, tag, self._digest(headers)))
        images.sort()
        return images

    def _delete_old(self):
        for _, tag, digest in self._tags()[: -self.keep]:
            if not digest:
                continue
            self._call(
                "DELETE",
                f"/v2/{self.name}/manifests/{digest}",
                {"Accept": self.accept},
            )
            print(f"deleted {tag} {digest}")

    def _collect(self):
        code, output = docker.from_env().containers.get("registry").exec_run(
            [
                "registry",
                "garbage-collect",
                "/etc/docker/registry/config.yml",
                "--delete-untagged",
            ]
        )
        if code != 0:
            raise SystemExit(output.decode())


def main():
    RegistryRotation().run()


if __name__ == "__main__":
    main()
