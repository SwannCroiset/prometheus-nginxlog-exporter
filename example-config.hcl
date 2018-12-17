listen {
  port = 4040
}

#consul {
#  enable = true
#  address = "localhost:8500"
#  datacenter = "dc1"
#  scheme = "http"
#  token = ""
#  service {
#    id = "nginx-exporter"
#    name = "nginx-exporter"
#    tags = ["foo", "bar"]
#  }
#}

namespace "nginx" {
  source_files = [
    "peopledoc-web-https.access.log"
  ]
#  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\""
  format = "[$time_local] $msec \"$remote_user\" $remote_addr $host $request $request_uri $status $request_length $bytes_sent $body_bytes_sent \"$http_x_forwarded_for\" $request_time up_rt=$upstream_response_time up_ct=$upstream_connect_time up_ht=$upstream_header_time $ssl_cipher up=$upstream_addr \"$http_user_agent\" $http_referer ssl_cli_verify:$ssl_client_verify"

#  labels {
#    app = "magicapp"
#    foo = "bar"
#  }

#  relabel "user" {
#    from = "remote_user"
#    // whitelist = ["-", "user1", "user2"]
#  }
#
  relabel "uri" {
    from = "request_uri"
    match "/(static|media).*" {
      replacement = "static"
    }
    match ".*\\.(png|jpeg|js|css)$" {
      replacement = "static"
    }
    match "^(.*)\\?.*$" {
      replacement = "$1"
    }
    match "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}" {
      replacement = "uuid"
    }
    match "^/document.signing.*" {
      replacement = "/document-signing"
    }
    match "/[0-9]+" {
      replacement = "/_id_"
    }
#    match "^(.*)/[0-9]+[/-]?" {
#      replacement = "$1/_id_"
#    }
  }
  relabel "upstream" {
    from = "upstream_addr"
  }
#    split = 2
#
#    match "^(.+)$" {
#      replacement = "$1"
#    }
#  }
}
