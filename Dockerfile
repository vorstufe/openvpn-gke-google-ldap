FROM alpine
RUN apk update && apk add --no-cache ca-certificates iptables openssl openvpn openvpn-auth-ldap
