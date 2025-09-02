# Professional Guide: prplOS Interface Stack Mapping Based on TR-181 Standard

## Executive Summary

This professional guide provides comprehensive interface stack mapping for prplOS implementations based on the official TR-181-2-19-1 specification from the Broadband Forum. The interface stacking mechanism is the cornerstone of the Device:2 data model, enabling network interfaces and protocol layers to be modeled as independent data objects that can be stacked dynamically.

**Key Standard References:**
- **TR-181 Issue 2 Amendment 19 Corrigendum 1** (April 2025)
- **Device:2 Data Model** for CWMP Endpoints and USP Agents
- **RFC 2863** Interface MIB standards
- **OSI Layer Model** (Layers 1-3 restriction)

---

## 1. TR-181 Interface Stack Architecture Foundation

### 1.1 Core Principles

According to TR-181 specification, **interface objects are modeled as independent data objects that can be stacked, one on top of the other, using path references to dynamically define relationships between interfaces**. The standard restricts interface objects to definitions that operate at or below the IP network layer (OSI layers 1-3).

### 1.2 Interface Object Structure

**Every interface object contains a core set of parameters:**

| Parameter | Type | Purpose | TR-181 Requirement |
|-----------|------|---------|-------------------|
| `Enable` | Boolean | Administrative state (enabled/disabled) | MUST implement |
| `Status` | Enumeration | Operational state (Up/Down/Unknown/Dormant/NotPresent/LowerLayerDown/Error) | MUST implement |
| `Name` | String | Textual name chosen by CPE | MUST implement |
| `Alias` | String | Alternate name for Controller use | MUST implement |
| `LastChange` | UnsignedInt | Time since current operational state | MUST implement |
| `LowerLayers` | String list | Path references to lower interface objects | MUST implement |

**Standard Stats Parameters (within Stats sub-object):**
- BytesSent/BytesReceived
- PacketsSent/PacketsReceived  
- ErrorsSent/ErrorsReceived
- UnicastPackets/MulticastPackets/BroadcastPackets
- DiscardPackets/UnknownProtoPackets

---

## 2. prplOS Interface Stack Mapping Tables

### 2.1 Master Interface Hierarchy

Based on TR-181 Figure 10 (OSI Layers and Interface Objects), here's the complete interface hierarchy:

| OSI Layer | Interface Type | TR-181 Object Path | Stacking Rules | prplOS Implementation |
|-----------|----------------|-------------------|----------------|----------------------|
| **Layer 3** | IP Interface | `Device.IP.Interface.{i}` | Must reference lower layer | IP routing, DHCP, addressing |
| **Layer 2+** | Bridge Port | `Device.Bridging.Bridge.{i}.Port.{i}` | References physical/virtual interfaces | LAN/Guest/LCM bridge ports |
| **Layer 2+** | VLAN Termination | `Device.Ethernet.VLANTermination.{i}` | References Ethernet interface | VLAN tagging/untagging |
| **Layer 2** | Ethernet Interface | `Device.Ethernet.Interface.{i}` | References Ethernet Link | Physical ethernet ports |
| **Layer 2** | WiFi SSID | `Device.WiFi.SSID.{i}` | References WiFi Radio | Wireless access points |
| **Layer 1** | Ethernet Link | `Device.Ethernet.Link.{i}` | No lower layers (physical) | Physical connectivity |
| **Layer 1** | WiFi Radio | `Device.WiFi.Radio.{i}` | No lower layers (physical) | Radio hardware |

### 2.2 LAN Interface Stack Mapping

**Derived from TR-181 Section 4.2.1 (Lower Layers) and practical prplOS implementations:**

| Interface Component | TR-181 Path | Higher Layer Reference | Lower Layer Reference | Rationale |
|---------------------|-------------|----------------------|---------------------|-----------|
| **LAN IP Interface** | `Device.IP.Interface.1` | Router/Applications | `Device.Bridging.Bridge.1.Port.1` | **Why**: TR-181 requires IP interfaces to reference bridge ports for LAN connectivity. This enables DHCP server, routing, and subnet management for LAN clients. |
| **LAN Bridge Management Port** | `Device.Bridging.Bridge.1.Port.1` | `Device.IP.Interface.1` | `Device.Bridging.Bridge.1.Port.{2,3,4...}` | **Why**: TR-181 Bridge model uses management ports (upward-facing) to connect to IP layer and non-management ports (downward-facing) for physical interfaces. |
| **LAN Bridge Port 2** | `Device.Bridging.Bridge.1.Port.2` | `Device.Bridging.Bridge.1.Port.1` | `Device.Ethernet.Interface.1` | **Why**: Non-management bridge ports provide the connection between bridge and physical ethernet ports, enabling L2 switching. |
| **LAN Bridge Port 3** | `Device.Bridging.Bridge.1.Port.3` | `Device.Bridging.Bridge.1.Port.1` | `Device.Ethernet.Interface.2` | **Why**: Multiple ports enable multi-port bridging as per 802.1D standard referenced in TR-181. |
| **LAN Bridge Port 4** | `Device.Bridging.Bridge.1.Port.4` | `Device.Bridging.Bridge.1.Port.1` | `Device.WiFi.SSID.1` | **Why**: WiFi SSID integration into bridge enables unified wired/wireless LAN as required by residential gateway standards. |
| **Ethernet Interface 1** | `Device.Ethernet.Interface.1` | `Device.Bridging.Bridge.1.Port.2` | `Device.Ethernet.Link.1` | **Why**: TR-181 separates interface (protocol) from link (physical) for abstraction and management flexibility. |
| **Ethernet Interface 2** | `Device.Ethernet.Interface.2` | `Device.Bridging.Bridge.1.Port.3` | `Device.Ethernet.Link.2` | **Why**: Each physical port requires separate interface instance for individual port management and statistics. |
| **WiFi SSID 1** | `Device.WiFi.SSID.1` | `Device.Bridging.Bridge.1.Port.4` | `Device.WiFi.Radio.1` | **Why**: SSID represents the service set, while Radio represents the physical transmission medium per 802.11 standards. |

**Configuration Example:**
```bash
# LAN Bridge Configuration (br-lan - 10.0.2.0/24)
LowerLayers: Device.IP.Interface.1 → Device.Bridging.Bridge.1.Port.1
LowerLayers: Device.Bridging.Bridge.1.Port.1 → Device.Bridging.Bridge.1.Port.2,Device.Bridging.Bridge.1.Port.3,Device.Bridging.Bridge.1.Port.4
```

### 2.3 Guest Network Interface Stack Mapping

**Based on TR-181 VLAN Termination and Bridge segregation principles:**

| Interface Component | TR-181 Path | Higher Layer Reference | Lower Layer Reference | Rationale |
|---------------------|-------------|----------------------|---------------------|-----------|
| **Guest IP Interface** | `Device.IP.Interface.2` | Guest applications | `Device.Bridging.Bridge.2.Port.1` | **Why**: TR-181 requires network isolation through separate IP interfaces. Guest network needs independent subnet (192.168.2.0/24) with controlled access policies. |
| **Guest Bridge Management Port** | `Device.Bridging.Bridge.2.Port.1` | `Device.IP.Interface.2` | `Device.Bridging.Bridge.2.Port.{2,3}` | **Why**: Separate bridge instance provides Layer 2 isolation from main LAN, essential for security and bandwidth management per TR-181 bridging model. |
| **Guest Bridge Port 2** | `Device.Bridging.Bridge.2.Port.2` | `Device.Bridging.Bridge.2.Port.1` | `Device.WiFi.SSID.2` | **Why**: Guest access typically provided via dedicated WiFi SSID with restricted capabilities and separate authentication. |
| **Guest Bridge Port 3** | `Device.Bridging.Bridge.2.Port.3` | `Device.Bridging.Bridge.2.Port.1` | `Device.Ethernet.VLANTermination.1` | **Why**: Optional wired guest access through VLAN tagging on physical ethernet port provides flexibility for IoT devices or temporary access. |
| **Guest WiFi SSID** | `Device.WiFi.SSID.2` | `Device.Bridging.Bridge.2.Port.2` | `Device.WiFi.Radio.1` | **Why**: Reuses same physical radio but creates separate virtual access point with guest-specific security policies and bandwidth limits. |
| **Guest VLAN Interface** | `Device.Ethernet.VLANTermination.1` | `Device.Bridging.Bridge.2.Port.3` | `Device.Ethernet.Interface.3` | **Why**: VLAN termination enables tagging guest traffic (e.g., VLAN 100) for isolation even on shared physical infrastructure. |

**Security Rationale**: TR-181 bridge model enables traffic isolation where guest traffic cannot reach LAN resources, implementing enterprise-grade network segmentation.

### 2.4 Private Bridge Interface Stack

**For internal router functions and service isolation:**

| Interface Component | TR-181 Path | Higher Layer Reference | Lower Layer Reference | Rationale |
|---------------------|-------------|----------------------|---------------------|-----------|
| **Private IP Interface** | `Device.IP.Interface.3` | System services | `Device.Bridging.Bridge.3.Port.1` | **Why**: Private bridge supports internal router services like DNS forwarding, captive portal, or management interfaces that shouldn't be directly accessible from LAN. |
| **Private Bridge Management** | `Device.Bridging.Bridge.3.Port.1` | `Device.IP.Interface.3` | `Device.Bridging.Bridge.3.Port.2` | **Why**: Provides controlled access to private services with ability to apply specific QoS and security policies per TR-181 classification model. |
| **Private Bridge Port** | `Device.Bridging.Bridge.3.Port.2` | `Device.Bridging.Bridge.3.Port.1` | Software-defined interface | **Why**: Connects to virtual or loopback interfaces for internal services without consuming physical ports. |

### 2.5 LCM (Life Cycle Management) Interface Stack

**For container and application lifecycle management based on prpl LCM standards:**

| Interface Component | TR-181 Path | Higher Layer Reference | Lower Layer Reference | Rationale |
|---------------------|-------------|----------------------|---------------------|-----------|
| **LCM IP Interface** | `Device.IP.Interface.4` | Container runtime | `Device.Bridging.Bridge.4.Port.1` | **Why**: LCM requires dedicated network namespace (192.168.5.0/24) for container management traffic, separate from user data per prpl LCM specification. |
| **LCM Bridge Management** | `Device.Bridging.Bridge.4.Port.1` | `Device.IP.Interface.4` | `Device.Bridging.Bridge.4.Port.{2,3,4}` | **Why**: Bridge enables multiple containers to share network while maintaining isolation from other services through TR-181 bridging rules. |
| **LCM Container Port 1** | `Device.Bridging.Bridge.4.Port.2` | `Device.Bridging.Bridge.4.Port.1` | `Device.SoftwareModules.ExecEnv.1.Interface` | **Why**: Each container execution environment gets dedicated bridge port for network access with individual traffic accounting and policy enforcement. |
| **LCM Container Port 2** | `Device.Bridging.Bridge.4.Port.3` | `Device.Bridging.Bridge.4.Port.1` | `Device.SoftwareModules.ExecEnv.2.Interface` | **Why**: Multiple container support with per-container network isolation and resource management capabilities. |
| **LCM Management Port** | `Device.Bridging.Bridge.4.Port.4` | `Device.Bridging.Bridge.4.Port.1` | Virtual interface | **Why**: Administrative access for LCM operations like container deployment, monitoring, and lifecycle events. |

### 2.6 WiFi Interface Stack Detailed Mapping

**Based on TR-181 WiFi model and 802.11 standards integration:**

| Interface Component | TR-181 Path | Higher Layer Reference | Lower Layer Reference | Rationale |
|---------------------|-------------|----------------------|---------------------|-----------|
| **WiFi Radio 1 (2.4GHz)** | `Device.WiFi.Radio.1` | Multiple SSIDs | Physical radio hardware | **Why**: TR-181 models physical radio separately from virtual access points, enabling multiple SSIDs per radio with different security and QoS policies. |
| **WiFi Radio 2 (5GHz)** | `Device.WiFi.Radio.2` | Multiple SSIDs | Physical radio hardware | **Why**: Dual-band support requires separate radio objects as per TR-181 WiFi theory of operation, enabling band steering and load balancing. |
| **Primary SSID (2.4GHz)** | `Device.WiFi.SSID.1` | LAN Bridge | `Device.WiFi.Radio.1` | **Why**: Primary access point for main LAN network with full access privileges and performance optimization. |
| **Primary SSID (5GHz)** | `Device.WiFi.SSID.2` | LAN Bridge | `Device.WiFi.Radio.2` | **Why**: Dual-band implementation of same network for optimal client device compatibility and performance. |
| **Guest SSID (2.4GHz)** | `Device.WiFi.SSID.3` | Guest Bridge | `Device.WiFi.Radio.1` | **Why**: Guest network on 2.4GHz for broader device compatibility with restricted access and bandwidth controls. |
| **Guest SSID (5GHz)** | `Device.WiFi.SSID.4` | Guest Bridge | `Device.WiFi.Radio.2` | **Why**: High-performance guest access for modern devices while maintaining network isolation. |

---

## 3. Interface Stack Validation Rules

### 3.1 TR-181 Compliance Requirements

**Based on TR-181 Section 4.2.1, the following validation rules MUST be enforced:**

| Rule Category | Requirement | Implementation | Failure Response |
|---------------|-------------|----------------|------------------|
| **Reference Integrity** | LowerLayers parameter MUST contain valid path references | CPE validates all references during configuration | Reject with InvalidParameterValue fault |
| **Circular Prevention** | No circular references allowed in stack | CPE checks for loops during LowerLayers update | Reject with InvalidParameterValue fault |
| **Strong References** | Deleted interfaces MUST be removed from LowerLayers | CPE automatically updates referencing objects | Automatic cleanup with notification |
| **Layer Ordering** | Higher layer interfaces cannot reference same-layer objects | CPE validates OSI layer compliance | Reject with InvalidParameterValue fault |
| **Physical Layer Rules** | Bottom layer interfaces have empty LowerLayers | Ethernet.Link, WiFi.Radio have no lower references | Enforced by data model constraints |

### 3.2 Operational State Dependencies

**TR-181 Section 4.2.3 defines stacking operational requirements:**

| Interface State | Lower Layer Requirement | Expected Behavior | Example |
|-----------------|------------------------|-------------------|---------|
| **Up** | At least one lower layer Up | Interface can transmit/receive | Bridge Up when one ethernet port Up |
| **LowerLayerDown** | All lower layers non-Up | Interface cannot function | Bridge Down when all ports Down |
| **Dormant** | Lower layer Dormant acceptable | Waiting for external events | WiFi SSID waiting for radio calibration |
| **Error** | Interface fault condition | Fault detected on interface | Ethernet interface hardware failure |

---

## 4. InterfaceStack Table Auto-Generation

### 4.1 TR-181 InterfaceStack Table Structure

**The InterfaceStack table (`Device.InterfaceStack.{i}`) is auto-generated by CPE based on LowerLayers parameters:**

| Table Row | HigherLayer | LowerLayer | Description |
|-----------|-------------|------------|-------------|
| 1 | `Device.IP.Interface.1` | `Device.Bridging.Bridge.1.Port.1` | LAN IP over Bridge |
| 2 | `Device.Bridging.Bridge.1.Port.1` | `Device.Bridging.Bridge.1.Port.2` | Bridge management over port |
| 3 | `Device.Bridging.Bridge.1.Port.2` | `Device.Ethernet.Interface.1` | Bridge port over ethernet |
| 4 | `Device.Ethernet.Interface.1` | `Device.Ethernet.Link.1` | Ethernet interface over link |
| 5 | `Device.IP.Interface.2` | `Device.Bridging.Bridge.2.Port.1` | Guest IP over Bridge |
| 6 | `Device.Bridging.Bridge.2.Port.1` | `Device.Bridging.Bridge.2.Port.2` | Guest bridge management |
| 7 | `Device.Bridging.Bridge.2.Port.2` | `Device.WiFi.SSID.2` | Guest bridge over WiFi |
| 8 | `Device.WiFi.SSID.2` | `Device.WiFi.Radio.1` | Guest SSID over radio |

### 4.2 Automatic Table Maintenance Rules

**CPE MUST autonomously maintain InterfaceStack table per TR-181 requirements:**

| Trigger Event | Required Action | Implementation |
|---------------|-----------------|----------------|
| **LowerLayers parameter updated** | Add/remove corresponding InterfaceStack rows | Real-time table synchronization |
| **Interface instance deleted** | Remove all referencing InterfaceStack rows | Cascading cleanup with notifications |
| **Interface instance added** | Add new InterfaceStack rows when referenced | Automatic population |
| **Stranded interfaces** | Exclude from InterfaceStack table | Only connected interfaces appear |

---

## 5. Network-Specific Implementation Guidelines

### 5.1 LAN Network (br-lan) - Subnet: 10.0.2.0/24

**Purpose**: Main internal network for trusted devices
**Security Level**: Full access to router services and internet

```
Interface Stack Flow:
Applications/Router Services
    ↓
Device.IP.Interface.1 (10.0.2.1/24)
    ↓
Device.Bridging.Bridge.1.Port.1 (Management Port)
    ↓
Device.Bridging.Bridge.1.Port.{2,3,4} (Physical Ports)
    ↓
Device.Ethernet.Interface.{1,2} + Device.WiFi.SSID.1
    ↓
Device.Ethernet.Link.{1,2} + Device.WiFi.Radio.1
```

**Key Features**:
- DHCP server enabled (IP range: 10.0.2.10-10.0.2.200)
- Full QoS classification support
- Inter-VLAN routing allowed
- UPnP/DLNA services accessible

### 5.2 Guest Network (br-guest) - Subnet: 192.168.2.0/24

**Purpose**: Isolated network for untrusted guest devices
**Security Level**: Internet access only, no internal network access

```
Interface Stack Flow:
Guest Applications (Limited)
    ↓
Device.IP.Interface.2 (192.168.2.1/24)
    ↓
Device.Bridging.Bridge.2.Port.1 (Management Port)
    ↓
Device.Bridging.Bridge.2.Port.{2,3} (Guest Access Ports)
    ↓
Device.WiFi.SSID.2 + Device.Ethernet.VLANTermination.1
    ↓
Device.WiFi.Radio.1 + Device.Ethernet.Interface.3
```

**Key Features**:
- Isolated DHCP scope (192.168.2.10-192.168.2.100)
- Bandwidth limiting per TR-181 QoS model
- Captive portal support
- No access to LAN subnet (firewall rules)

### 5.3 LCM Network (br-lcm) - Subnet: 192.168.5.0/24

**Purpose**: Container lifecycle management and orchestration
**Security Level**: Administrative access with service-specific policies

```
Interface Stack Flow:
Container Runtime/Management Services
    ↓
Device.IP.Interface.4 (192.168.5.1/24)
    ↓
Device.Bridging.Bridge.4.Port.1 (Management Port)
    ↓
Device.Bridging.Bridge.4.Port.{2,3,4} (Container/Service Ports)
    ↓
Device.SoftwareModules.ExecEnv.{i}.Interface + Virtual Interfaces
    ↓
Container Network Namespace
```

**Key Features**:
- Container networking per OCI standards
- Service discovery and load balancing
- Resource monitoring and accounting
- Integration with prpl LCM APIs

---

## 6. Configuration Commands and Examples

### 6.1 TR-181 Configuration via UBUS (prplOS)

```bash
# Query current interface stack
ubus call scald.tr-181 list '{"path": ["Device", "InterfaceStack"]}'

# Get bridge configuration
ubus call scald.tr-181 get '{"path": ["Device", "Bridging", "Bridge", "1"]}'

# Set lower layers for bridge port
ubus call scald.tr-181 set '{
    "path": ["Device", "Bridging", "Bridge", "1", "Port", "2"], 
    "name": "LowerLayers", 
    "value": "Device.Ethernet.Interface.1"
}'

# Add new bridge port
ubus call scald.tr-181 add '{
    "path": ["Device", "Bridging", "Bridge", "2", "Port"], 
    "name": "1"
}'
```

### 6.2 Validation Commands

```bash
# Verify interface operational status
ubus call scald.tr-181 get '{"path": ["Device", "Ethernet", "Interface", "1"], "name": "Status"}'

# Check interface statistics
ubus call scald.tr-181 get '{"path": ["Device", "Ethernet", "Interface", "1", "Stats"]}'

# Validate bridge learning table
ubus call scald.tr-181 list '{"path": ["Device", "Bridging", "Bridge", "1", "FDBEntry"]}'
```

---

## 7. Troubleshooting and Best Practices

### 7.1 Common Interface Stack Issues

| Problem | Symptoms | Root Cause | Solution |
|---------|----------|------------|----------|
| **LowerLayerDown Status** | Interface shows Down but hardware OK | Lower layer interface disabled/failed | Check lower layer Status, verify Enable=true |
| **Missing InterfaceStack entries** | Interface not visible in stack table | Stranded interface (no references) | Add LowerLayers reference to connect interface |
| **Bridge not forwarding** | Devices can't communicate on same bridge | Bridge ports not configured properly | Verify bridge port LowerLayers point to physical interfaces |
| **Guest isolation failure** | Guest devices access LAN resources | Incorrect bridge assignment | Ensure guest interfaces reference separate bridge instance |

### 7.2 Performance Optimization

| Optimization | Implementation | Benefit |
|--------------|----------------|---------|
| **Hardware Offloading** | Configure switch chip integration | Reduced CPU load for packet forwarding |
| **QoS Classification** | Implement per-interface traffic classes | Improved application performance |
| **Bridge Learning** | Optimize MAC address table size | Faster L2 forwarding decisions |
| **Interface Aggregation** | Use bonding for multiple physical ports | Increased bandwidth and redundancy |

---

## 8. Compliance Checklist

### 8.1 TR-181 Standard Compliance

- [ ] **Interface Object Structure**: All interfaces implement core parameters (Enable, Status, Name, Alias, LastChange, LowerLayers)
- [ ] **Stats Parameters**: All interfaces provide standard statistics counters
- [ ] **LowerLayers Validation**: Strong reference checking implemented
- [ ] **InterfaceStack Table**: Automatic generation and maintenance
- [ ] **Operational State Logic**: Proper state transitions based on lower layer status
- [ ] **Bridge Model Compliance**: 802.1D/802.1Q standards integration
- [ ] **WiFi Integration**: Proper Radio/SSID separation per TR-181 WiFi model

### 8.2 prplOS Specific Requirements

- [ ] **LCM Integration**: Container networking support via bridge model
- [ ] **Guest Network Isolation**: Security policy enforcement
- [ ] **QoS Implementation**: Traffic classification and scheduling
- [ ] **Management Interface**: UBUS/TR-181 API compatibility
- [ ] **Statistics Collection**: Real-time monitoring capabilities

---

## Conclusion

This professional guide provides the definitive reference for implementing TR-181 compliant interface stack mapping in prplOS environments. The mapping ensures proper network isolation, performance optimization, and management capabilities while maintaining full compliance with Broadband Forum standards.

**Key Success Factors**:
1. **Strict adherence to TR-181 interface stacking rules**
2. **Proper bridge model implementation for network isolation**
3. **Comprehensive validation and error handling**
4. **Integration with prplOS-specific features (LCM, guest networks)**
5. **Performance optimization through hardware offloading where possible**

For additional implementation details, refer to the complete TR-181-2-19-1 specification document and prplOS-specific documentation available through the prpl Foundation GitLab repositories.