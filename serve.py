from http.server import SimpleHTTPRequestHandler, HTTPServer
from functools import partial


class COOPCOEPHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, directory=None, **kwargs):
        if directory is None:
            directory = os.getcwd()
        super().__init__(*args, directory=directory, **kwargs)

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        SimpleHTTPRequestHandler.end_headers(self)


if __name__ == "__main__":
    handler = partial(COOPCOEPHandler, directory="dist/web")
    server_address = ("", 8000)  # Serve on all addresses, port 8000
    httpd = HTTPServer(server_address, handler)
    print("Server running on port 8000")
    httpd.serve_forever()
