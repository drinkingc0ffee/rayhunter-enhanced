# Telecommunications Protocol Parser

## Cellular Network Message Parsing Library

This library provides parsing capabilities for telecommunications protocol messages, specifically focusing on cellular network protocols like LTE RRC (Radio Resource Control). It enables Rayhunter to decode and analyze cellular network messages captured from mobile devices.

### 🎯 Purpose

The telcom-parser library is essential for:
- **Decoding cellular protocol messages** from captured network data
- **Extracting network parameters** like cell IDs, signal information, and network configurations
- **Understanding network behavior** for IMSI catcher detection
- **Converting binary protocol data** into readable, analyzable formats

### 📡 Supported Protocols

- **LTE RRC (Radio Resource Control)**: Core 4G protocol for network configuration and control
- **3GPP Standards Compliance**: Based on official telecommunications standards
- **ASN.1 Message Formats**: Industry-standard message encoding/decoding

### 🔧 Key Features

- **Automatic message parsing** from binary cellular data
- **Standards-compliant decoding** using 3GPP ASN.1 specifications  
- **Rust-native implementation** for performance and safety
- **Integration with Rayhunter** for real-time cellular analysis

### 🚀 Usage

This library is primarily used as a dependency within the Rayhunter system to:

1. **Parse captured cellular messages** from QMDL diagnostic logs
2. **Extract meaningful network information** for analysis
3. **Detect anomalous network behavior** that may indicate surveillance devices
4. **Generate structured data** for further investigation

### 📚 Technical Foundation

The parser is built using:
- **ASN.1 specifications** from 3GPP telecommunications standards
- **Hampi parser generator** for automatic code generation from ASN.1 specs
- **uPER encoding** (unaligned Packed Encoding Rules) for message format compliance

### 🤝 Integration

This library integrates seamlessly with other Rayhunter components:
- **QMDL log processing** for cellular diagnostic data
- **Real-time analysis engine** for network behavior monitoring
- **Web interface** for displaying decoded network information
- **Export functionality** for further analysis in external tools

For more information about using this parser within Rayhunter, see the main Rayhunter documentation.
