# Real prplOS Interface Stack Analysis and Mapping

## Executive Summary

This analysis is based on an actual prplOS device InterfaceStack table showing a sophisticated multi-service residential gateway with:
- **4 Ethernet ports** (ETH0-ETH3, with ETH0 as WAN)
- **3 WiFi radios** (2.4GHz, 5GHz, 6GHz) with multiple SSIDs each
- **Separate network bridges** for LAN, Guest, and LCM isolation
- **Multiple WAN services** (Internet, VoIP, IPTV, Management)
- **DS-Lite IPv6 transition** tunneling support
- **Logical interface abstraction** layer

---

## 1. Complete Interface Stack Hierarchy

### 1.1 Master Stack Overview

| Stack Level | Interface Count | Function | Example |
|-------------|----------------|----------|---------|
| **Logical Layer** | 7 interfaces | Service abstraction | wan, lan, guest, lcm, voip, mgmt, iptv |
| **IP Layer** | 11 interfaces | L3 routing/addressing | Device.IP.Interface.{1-11} |
| **Bridge Layer** | 3 bridges, 11 ports | L2 switching/isolation | LAN Bridge (9 ports), Guest Bridge, LCM Bridge |
| **Link Layer** | 5 links | Protocol abstraction | ethernet_wan, bridge_lan, bridge_guest, bridge_lcm, loopback |
| **Interface Layer** | 5+ interfaces | Physical/Virtual interfaces | ETH0-ETH4, WiFi SSIDs |
| **Physical Layer** | 4 ethernet + 3 radios | Hardware connectivity | Ethernet ports, WiFi radios |

---

## 2. Network Service Mapping Tables

### 2.1 Logical to IP Interface Mapping

| Logical Interface | TR-181 Path | Higher Layer Service | Lower Layer IP Interface | Network Purpose |
|-------------------|-------------|---------------------|------------------------|-----------------|
| **wan** | `Device.Logical.Interface.1` | Router/NAT services | `Device.IP.Interface.2` | Internet connectivity |
| **lan** | `Device.Logical.Interface.2` | LAN services | `Device.IP.Interface.3` | Internal network (likely 192.168.1.0/24) |
| **guest** | `Device.Logical.Interface.3` | Guest services | `Device.IP.Interface.4` | Isolated guest network |
| **lcm** | `Device.Logical.Interface.4` | Container management | `Device.IP.Interface.5` | Lifecycle Management (192.168.5.0/24) |
| **voip** | `Device.Logical.Interface.5` | VoIP services | `Device.IP.Interface.9` | Voice over IP telephony |
| **mgmt** | `Device.Logical.Interface.6` | Management services | `Device.IP.Interface.11` | Device management/monitoring |
| **iptv** | `Device.Logical.Interface.7` | IPTV services | `Device.IP.Interface.10` | Television streaming |

**Explanation**: The logical layer provides service-level abstraction, allowing the same physical infrastructure to support multiple services with different QoS, security, and routing policies.

### 2.2 IP Interface to Network Link Mapping

| IP Interface | Alias | Network Type | Lower Layer Link | Physical Connection | Service Purpose |
|--------------|-------|--------------|------------------|--------------------|--------------------|
| `Device.IP.Interface.1` | loopback | Internal | `Device.Ethernet.Link.1` | Software loopback | System services |
| `Device.IP.Interface.2` | wan | WAN | `Device.Ethernet.Link.2` | ETH0 (WAN port) | Internet access |
| `Device.IP.Interface.3` | lan | Bridge | `Device.Ethernet.Link.3` | LAN Bridge | Internal network |
| `Device.IP.Interface.4` | guest | Bridge | `Device.Ethernet.Link.4` | Guest Bridge | Visitor access |
| `Device.IP.Interface.5` | lcm | Bridge | `Device.Ethernet.Link.5` | LCM Bridge | Container management |
| `Device.IP.Interface.9` | voip | WAN | `Device.Ethernet.Link.2` | ETH0 (shared) | VoIP telephony |
| `Device.IP.Interface.10` | iptv | WAN | `Device.Ethernet.Link.2` | ETH0 (shared) | IPTV streaming |
| `Device.IP.Interface.11` | mgmt | WAN | `Device.Ethernet.Link.2` | ETH0 (shared) | Remote management |

**Key Insight**: Multiple IP interfaces (wan, voip, iptv, mgmt) share the same physical WAN connection (`Device.Ethernet.Link.2`), implementing service separation through VLANs or policy routing.

---

## 3. Bridge Architecture Analysis

### 3.1 LAN Bridge Detailed Mapping (Bridge.1)

| Port Instance | Port Alias | Higher Layer | Lower Layer Interface | Physical Connection | Purpose |
|---------------|------------|--------------|----------------------|--------------------|---------| 
| **Management Port** | lan_bridge | `Device.Bridging.Bridge.1.Port.1` | Bridge aggregation | All LAN ports | Bridge control |
| **Port 2** | ETH1 | Bridge management | `Device.Ethernet.Interface.2` | Physical ETH1 | Wired LAN client |
| **Port 3** | ETH2 | Bridge management | `Device.Ethernet.Interface.3` | Physical ETH2 | Wired LAN client |
| **Port 4** | ETH3 | Bridge management | `Device.Ethernet.Interface.4` | Physical ETH3 | Wired LAN client |
| **Port 5** | ETH4 | Bridge management | `Device.Ethernet.Interface.5` | Physical ETH4 | Wired LAN client |
| **Port 6** | default_wl0 | Bridge management | `Device.WiFi.SSID.1` | 2.4GHz Primary SSID | WiFi LAN access |
| **Port 7** | ep6g0 | Bridge management | `Device.WiFi.SSID.2` | 6GHz Enterprise SSID | High-performance WiFi |
| **Port 8** | default_wl1 | Bridge management | `Device.WiFi.SSID.3` | 5GHz Primary SSID | WiFi LAN access |
| **Port 9** | ep5g0 | Bridge management | `Device.WiFi.SSID.4` | 5GHz Enterprise SSID | High-performance WiFi |
| **Port 10** | default_wl2 | Bridge management | `Device.WiFi.SSID.5` | Additional radio SSID | Extended coverage |
| **Port 11** | ep2g0 | Bridge management | `Device.WiFi.SSID.6` | 2.4GHz Enterprise SSID | Legacy device support |

**Bridge Architecture Explanation**:
- **Management Port (Port.1)**: Acts as the upward-facing interface connecting to IP layer
- **Physical Ports (2-5)**: Four Ethernet ports for wired devices
- **WiFi Ports (6-11)**: Six WiFi SSIDs across three radios providing comprehensive wireless coverage

### 3.2 Guest and LCM Bridge Summary

| Bridge | Management Port | Purpose | Isolation Level | Network Scope |
|--------|----------------|---------|-----------------|---------------|
| **Bridge.2** | guest_bridge | Guest network isolation | Complete LAN isolation | Internet-only access |
| **Bridge.3** | lcm_bridge | Container management | Service-level isolation | Container orchestration |

---

## 4. WiFi Radio and SSID Architecture

### 4.1 Complete WiFi Mapping

| Radio | Frequency Band | SSID Instance | SSID Alias | Bridge Port | Service Type | Target Devices |
|-------|---------------|---------------|------------|-------------|--------------|----------------|
| **Radio.1** | 2.4GHz (wl0) | SSID.1 | DEFAULT_WL0_fake | Bridge.1.Port.6 | Primary LAN | Legacy devices, IoT |
| **Radio.1** | 2.4GHz (wl0) | SSID.2 | ep6g0_fake | Bridge.1.Port.7 | Enterprise | High-security clients |
| **Radio.1** | 2.4GHz (wl0) | SSID.7 | DEFAULT_WL0_1 | Additional SSID | Secondary | Guest or isolated |
| **Radio.1** | 2.4GHz (wl0) | SSID.8 | DEFAULT_WL0_2 | Additional SSID | Tertiary | Special purpose |
| **Radio.2** | 5GHz (wl1) | SSID.3 | DEFAULT_WL1_fake | Bridge.1.Port.8 | Primary LAN | High-performance devices |
| **Radio.2** | 5GHz (wl1) | SSID.4 | ep5g0_fake | Bridge.1.Port.9 | Enterprise | Business clients |
| **Radio.2** | 5GHz (wl1) | SSID.11 | DEFAULT_WL1_1 | Additional SSID | Secondary | Extended coverage |
| **Radio.2** | 5GHz (wl1) | SSID.12 | DEFAULT_WL1_2 | Additional SSID | Tertiary | Special purpose |
| **Radio.3** | 6GHz (wl2) | SSID.5 | DEFAULT_WL2_fake | Bridge.1.Port.10 | Primary LAN | WiFi 6E devices |
| **Radio.3** | 6GHz (wl2) | SSID.6 | ep2g0_fake | Bridge.1.Port.11 | Enterprise | Ultra-high performance |
| **Radio.3** | 6GHz (wl2) | SSID.15 | DEFAULT_WL2_1 | Additional SSID | Secondary | Extended 6GHz |
| **Radio.3** | 6GHz (wl2) | SSID.16 | DEFAULT_WL2_2 | Additional SSID | Tertiary | Special purpose |

**WiFi Architecture Insights**:
- **Tri-band setup**: 2.4GHz, 5GHz, and 6GHz radios for optimal device compatibility and performance
- **Multiple SSIDs per radio**: Enables network segmentation and service differentiation
- **Enterprise profiles**: Separate "ep" (enterprise) SSIDs for business-grade security and QoS
- **Bridge integration**: All WiFi SSIDs integrate seamlessly with wired Ethernet through bridge ports

---

## 5. WAN Services and Tunneling

### 5.1 WAN Service Separation

| Service | IP Interface | Logical Interface | Physical Connection | VLAN/Separation Method | Purpose |
|---------|-------------|-------------------|-------------------|----------------------|---------|
| **Internet** | IP.Interface.2 | Logical.Interface.1 | Ethernet.Link.2 (ETH0) | Primary/Default | General internet access |
| **VoIP** | IP.Interface.9 | Logical.Interface.5 | Ethernet.Link.2 (ETH0) | Service-based VLAN | Voice telephony |
| **IPTV** | IP.Interface.10 | Logical.Interface.7 | Ethernet.Link.2 (ETH0) | Multicast VLAN | Television service |
| **Management** | IP.Interface.11 | Logical.Interface.6 | Ethernet.Link.2 (ETH0) | Management VLAN | Remote administration |

### 5.2 Advanced Tunneling Configuration

| Tunnel Type | Entry Point | Exit Point | Purpose | Implementation |
|-------------|-------------|------------|---------|----------------|
| **DS-Lite** | IP.Interface.7 (DSLite-entry) | IP.Interface.8 (DSLite-exit) | IPv6 transition | Dual-Stack Lite tunneling |
| **PPPoE** | PPP.Interface.1 | Ethernet.Link.2 | WAN authentication | Point-to-Point over Ethernet |

**Service Separation Rationale**:
- **QoS Differentiation**: Each service can have dedicated bandwidth allocation
- **Security Isolation**: VoIP and IPTV traffic separated from general internet
- **Service Provider Requirements**: Enables triple-play service delivery (Internet + Voice + TV)

---

## 6. Network Flow Analysis

### 6.1 Typical Data Flow Paths

#### LAN Client Internet Access:
```
WiFi Device → WiFi.Radio.1 → WiFi.SSID.1 → Bridge.1.Port.6 → 
Bridge.1.Port.1 → Ethernet.Link.3 → IP.Interface.3 → 
Logical.Interface.2 → Routing → Logical.Interface.1 → 
IP.Interface.2 → Ethernet.Link.2 → ETH0 → Internet
```

#### VoIP Call Flow:
```
VoIP Phone → Ethernet.Interface.2 → Bridge.1.Port.2 → Bridge.1.Port.1 → 
Ethernet.Link.3 → IP.Interface.3 → QoS Classification → 
IP.Interface.9 → Logical.Interface.5 → Ethernet.Link.2 → 
ETH0 → VoIP Provider
```

#### Container Management:
```
LCM Service → IP.Interface.5 → Logical.Interface.4 → 
Ethernet.Link.5 → Bridge.3.Port.1 → Container Network
```

---

## 7. Configuration Insights and Best Practices

### 7.1 Advanced Features Identified

| Feature | Implementation | Benefit |
|---------|----------------|---------|
| **Multi-SSID per Radio** | Up to 4 SSIDs per radio | Network segmentation without additional hardware |
| **Service VLANs** | Multiple IP interfaces over single WAN | Service provider integration (triple-play) |
| **Bridge Isolation** | Separate bridges for LAN/Guest/LCM | Security and performance isolation |
| **Enterprise Profiles** | Dedicated "ep" SSIDs | Business-grade WiFi with enhanced security |
| **Logical Abstraction** | Logical interfaces over IP interfaces | Service-level management and monitoring |
| **Tunneling Support** | DS-Lite and PPPoE | IPv6 transition and authentication |

### 7.2 Performance Optimization

| Optimization Area | Implementation | Impact |
|-------------------|----------------|---------|
| **WiFi Band Steering** | Tri-band radio setup | Optimal client distribution across frequency bands |
| **Bridge Hardware Offload** | Multiple bridge instances | Reduced CPU load for L2 forwarding |
| **Service QoS** | Per-service IP interfaces | Guaranteed bandwidth for critical services |
| **Container Isolation** | Dedicated LCM bridge | Prevents container traffic from affecting user experience |

### 7.3 Security Architecture

| Security Layer | Implementation | Protection |
|---------------|----------------|-------------|
| **Network Isolation** | Separate bridges | Guest traffic cannot reach LAN resources |
| **Service Separation** | Multiple WAN IP interfaces | VoIP/IPTV isolated from general internet |
| **Enterprise WiFi** | Dedicated "ep" SSIDs | Enhanced security for business devices |
| **Management Isolation** | Separate management IP interface | Administrative access protection |

---

## 8. Troubleshooting Guide

### 8.1 Common Issues and Solutions

| Problem | Likely Cause | Investigation | Solution |
|---------|--------------|---------------|----------|
| **WiFi clients can't connect** | SSID not bridged properly | Check Bridge.1.Port.{6-11} status | Verify WiFi SSID to bridge port mapping |
| **Guest network accessing LAN** | Incorrect bridge assignment | Verify guest devices use Bridge.2 | Ensure guest SSIDs point to guest bridge |
| **VoIP quality issues** | QoS misconfiguration | Check IP.Interface.9 traffic classification | Configure proper QoS policies for VoIP |
| **Container networking fails** | LCM bridge misconfigured | Verify Bridge.3 and Ethernet.Link.5 | Check LCM bridge port configuration |
| **Internet connectivity loss** | WAN interface down | Check Ethernet.Link.2 and IP.Interface.2 | Verify WAN physical connection and IP config |

### 8.2 Validation Commands

```bash
# Check specific interface stack entry
ubus call scald.tr-181 get '{"path": ["Device", "InterfaceStack", "31"]}'

# Verify bridge port configuration  
ubus call scald.tr-181 get '{"path": ["Device", "Bridging", "Bridge", "1", "Port", "6"]}'

# Check WiFi SSID to radio mapping
ubus call scald.tr-181 get '{"path": ["Device", "WiFi", "SSID", "1"]}'

# Verify IP interface status
ubus call scald.tr-181 get '{"path": ["Device", "IP", "Interface", "3"], "name": "Status"}'
```

---

## Conclusion

This real prplOS configuration demonstrates a sophisticated enterprise-grade residential gateway with:

- **Advanced WiFi Architecture**: Tri-band setup with multiple SSIDs per radio
- **Service Provider Integration**: Support for internet, VoIP, IPTV, and management services
- **Container Support**: Dedicated LCM bridge for modern application deployment
- **Network Security**: Proper isolation between LAN, guest, and service networks
- **Performance Optimization**: Hardware-accelerated bridging and QoS support

The configuration follows TR-181 standards perfectly while implementing prplOS-specific enhancements for container lifecycle management and advanced WiFi features.