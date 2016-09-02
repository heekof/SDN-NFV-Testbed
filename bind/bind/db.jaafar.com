$TTL 5m ; Default TTL

; SOA, NS and A record for DNS server itself
@                 3600 IN SOA  ns.jaafar.com. admin.jaafar.com. ( 2014010800 ; Serial
                                          3600       ; Refresh
                                          3600       ; Retry
                                          3600       ; Expire
                                          300 )      ; Minimum TTL
@                 3600 IN NS   ns
ns                3600 IN A    157.159.232.152 ; IPv4 address of BIND server

; bono
; ====
;
; Per-node records - not required to have both IPv4 and IPv6 records
bono                 IN A     157.159.232.174
;
; Cluster A and AAAA records - UEs that don't support RFC 3263 will simply
; resolve the A or AAAA records and pick randomly from this set of addresses.
@                      IN A     157.159.232.174
;
; NAPTR and SRV records - these indicate a preference for TCP and then resolve
; to port 5060 on the per-node records defined above.
@                      IN NAPTR 1 1 "S" "SIP+D2T" "" _sip._tcp
@                      IN NAPTR 2 1 "S" "SIP+D2U" "" _sip._udp
_sip._tcp              IN SRV   0 0 5060 bono
; sprout
; ======
;
; Per-node records - not required to have both IPv4 and IPv6 records
sprout.jaafar.com.               IN A     157.159.232.212
;
; Cluster A and AAAA records - P-CSCFs that don't support RFC 3263 will simply
; resolve the A or AAAA records and pick randomly from this set of addresses.
sprout                 IN A     157.159.232.212
;
; Cluster A and AAAA records - P-CSCFs that don't support RFC 3263 will simply
; resolve the A or AAAA records and pick randomly from this set of addresses.
scscf.sprout           IN A     157.159.232.212
;
; NAPTR and SRV records - these indicate TCP support only and then resolve
; to port 5054 on the per-node records defined above.
sprout                 IN NAPTR 1 1 "S" "SIP+D2T" "" _sip._tcp.sprout
_sip._tcp       IN SRV   0 0 5054 sprout
;
; NAPTR and SRV records for S-CSCF - these indicate TCP support only and
; then resolve to port 5054 on the per-node records defined above.
scscf.sprout           IN NAPTR 1 1 "S" "SIP+D2T" "" _sip._tcp.scscf.sprout
_sip._tcp.scscf IN SRV   0 0 5054 sprout
;
; Cluster A and AAAA records - P-CSCFs that don't support RFC 3263 will simply
; resolve the A or AAAA records and pick randomly from this set of addresses.
icscf.sprout           IN A     157.159.232.212
;
; NAPTR and SRV records for I-CSCF - these indicate TCP support only and
; then resolve to port 5052 on the per-node records defined above.
icscf.sprout           IN NAPTR 1 1 "S" "SIP+D2T" "" _sip._tcp.icscf.sprout
_sip._tcp.icscf IN SRV   0 0 5052 sprout

; homestead
; =========
;
; Per-node records - not required to have both IPv4 and IPv6 records
homestead.jaafar.com.           IN A         157.159.232.166
;
; Cluster A and AAAA records - sprout picks randomly from these.
homestead.jaafar.com                     IN A         157.159.232.166
;
; (No need for NAPTR or SRV records as homestead doesn't handle SIP traffic.)

; homer
; =====
;
; Per-node records - not required to have both IPv4 and IPv6 records
homer.jaafar.com.                IN A     157.159.232.179
;
; Cluster A and AAAA records - sprout picks randomly from these.
homer.jaafar.com                  IN A     157.159.232.179
;
; (No need for NAPTR or SRV records as homer doesn't handle SIP traffic.)

; ralf
; =====
;
; Per-node records - not required to have both IPv4 and IPv6 records
ralf.jaafar.com.               IN A     157.159.232.165
;
; Cluster A and AAAA records - sprout and bono pick randomly from these.
ralf.jaafar.com                  IN A     157.159.232.165
;
; (No need for NAPTR or SRV records as ralf doesn't handle SIP traffic.)

; ellis
; =====
;
; ellis is not clustered, so there's only ever one node.
;
; Per-node record - not required to have both IPv4 and IPv6 records
ellis.jaafar.com.                IN A     157.159.232.198
;
; "Cluster"/access A and AAAA record
ellis.jaafar.com.                  IN A     157.159.232.198
