//! Enumerates some relevant diag log codes. Copied from QCSuper

// These are 2G-related log types.

pub const LOG_GSM_RR_SIGNALING_MESSAGE_C: u32 = 0x512f;

pub const DCCH: u32 = 0x00;
pub const BCCH: u32 = 0x01;
pub const L2_RACH: u32 = 0x02;
pub const CCCH: u32 = 0x03;
pub const SACCH: u32 = 0x04;
pub const SDCCH: u32 = 0x05;
pub const FACCH_F: u32 = 0x06;
pub const FACCH_H: u32 = 0x07;
pub const L2_RACH_WITH_NO_DELAY: u32 = 0x08;

// These are GPRS-related log types.

pub const LOG_GPRS_MAC_SIGNALLING_MESSAGE_C: u32 = 0x5226;

pub const PACCH_RRBP_CHANNEL: u32 = 0x03;
pub const UL_PACCH_CHANNEL: u32 = 0x04;
pub const DL_PACCH_CHANNEL: u32 = 0x83;

pub const PACKET_CHANNEL_REQUEST: u32 = 0x20;

// These are 5G-related log types.

pub const LOG_NR_RRC_OTA_MSG_LOG_C: u32 = 0xb821;

// These are 4G-related log types.

pub const LOG_LTE_RRC_OTA_MSG_LOG_C: u32 = 0xb0c0;
pub const LOG_LTE_NAS_ESM_OTA_IN_MSG_LOG_C: u32 = 0xb0e2;
pub const LOG_LTE_NAS_ESM_OTA_OUT_MSG_LOG_C: u32 = 0xb0e3;
pub const LOG_LTE_NAS_EMM_OTA_IN_MSG_LOG_C: u32 = 0xb0ec;
pub const LOG_LTE_NAS_EMM_OTA_OUT_MSG_LOG_C: u32 = 0xb0ed;

pub const LTE_BCCH_BCH_V0: u32 = 1;
pub const LTE_BCCH_DL_SCH_V0: u32 = 2;
pub const LTE_MCCH_V0: u32 = 3;
pub const LTE_PCCH_V0: u32 = 4;
pub const LTE_DL_CCCH_V0: u32 = 5;
pub const LTE_DL_DCCH_V0: u32 = 6;
pub const LTE_UL_CCCH_V0: u32 = 7;
pub const LTE_UL_DCCH_V0: u32 = 8;

pub const LTE_BCCH_BCH_V14: u32 = 1;
pub const LTE_BCCH_DL_SCH_V14: u32 = 2;
pub const LTE_MCCH_V14: u32 = 4;
pub const LTE_PCCH_V14: u32 = 5;
pub const LTE_DL_CCCH_V14: u32 = 6;
pub const LTE_DL_DCCH_V14: u32 = 7;
pub const LTE_UL_CCCH_V14: u32 = 8;
pub const LTE_UL_DCCH_V14: u32 = 9;

pub const LTE_BCCH_BCH_V9: u32 = 8;
pub const LTE_BCCH_DL_SCH_V9: u32 = 9;
pub const LTE_MCCH_V9: u32 = 10;
pub const LTE_PCCH_V9: u32 = 11;
pub const LTE_DL_CCCH_V9: u32 = 12;
pub const LTE_DL_DCCH_V9: u32 = 13;
pub const LTE_UL_CCCH_V9: u32 = 14;
pub const LTE_UL_DCCH_V9: u32 = 15;

pub const LTE_BCCH_BCH_V19: u32 = 1;
pub const LTE_BCCH_DL_SCH_V19: u32 = 3;
pub const LTE_MCCH_V19: u32 = 6;
pub const LTE_PCCH_V19: u32 = 7;
pub const LTE_DL_CCCH_V19: u32 = 8;
pub const LTE_DL_DCCH_V19: u32 = 9;
pub const LTE_UL_CCCH_V19: u32 = 10;
pub const LTE_UL_DCCH_V19: u32 = 11;

pub const LTE_BCCH_BCH_NB: u32 = 45;
pub const LTE_BCCH_DL_SCH_NB: u32 = 46;
pub const LTE_PCCH_NB: u32 = 47;
pub const LTE_DL_CCCH_NB: u32 = 48;
pub const LTE_DL_DCCH_NB: u32 = 49;
pub const LTE_UL_CCCH_NB: u32 = 50;
pub const LTE_UL_DCCH_NB: u32 = 52;

// These are 3G-related log types.

pub const RRCLOG_SIG_UL_CCCH: u32 = 0;
pub const RRCLOG_SIG_UL_DCCH: u32 = 1;
pub const RRCLOG_SIG_DL_CCCH: u32 = 2;
pub const RRCLOG_SIG_DL_DCCH: u32 = 3;
pub const RRCLOG_SIG_DL_BCCH_BCH: u32 = 4;
pub const RRCLOG_SIG_DL_BCCH_FACH: u32 = 5;
pub const RRCLOG_SIG_DL_PCCH: u32 = 6;
pub const RRCLOG_SIG_DL_MCCH: u32 = 7;
pub const RRCLOG_SIG_DL_MSCH: u32 = 8;
pub const RRCLOG_EXTENSION_SIB: u32 = 9;
pub const RRCLOG_SIB_CONTAINER: u32 = 10;

// 3G layer 3 packets:

pub const WCDMA_SIGNALLING_MESSAGE: u32 = 0x412f;

// Upper layers

pub const LOG_DATA_PROTOCOL_LOGGING_C: u32 = 0x11eb;

pub const LOG_UMTS_NAS_OTA_MESSAGE_LOG_PACKET_C: u32 = 0x713a;

// Additional log codes for enhanced cellular information capture

// LTE/4G Serving Cell and Neighbor Information
pub const LOG_LTE_ML1_SERVING_CELL_MEAS_AND_EVAL: u32 = 0xb0e0;
pub const LOG_LTE_ML1_NEIGHBOR_MEASUREMENTS: u32 = 0xb0e1;
pub const LOG_LTE_ML1_SERVING_CELL_INFO: u32 = 0xb0e4;
pub const LOG_LTE_ML1_INTRA_FREQ_MEAS: u32 = 0xb0e5;
pub const LOG_LTE_ML1_INTER_FREQ_MEAS: u32 = 0xb0e6;
pub const LOG_LTE_ML1_INTER_RAT_MEAS: u32 = 0xb0e7;
pub const LOG_LTE_ML1_CELL_RESEL_CANDIDATES: u32 = 0xb0e8;
pub const LOG_LTE_ML1_COMMON_DL_CONFIG: u32 = 0xb0ea;
pub const LOG_LTE_ML1_SERVING_CELL_COM_LOOP: u32 = 0xb0eb;

// LTE System Information
pub const LOG_LTE_RRC_MEAS_CFG: u32 = 0xb0c1;
pub const LOG_LTE_RRC_CELL_INFO: u32 = 0xb0c2;
pub const LOG_LTE_RRC_STATE: u32 = 0xb0c3;
pub const LOG_LTE_RRC_PLMN_SEARCH_INFO: u32 = 0xb0c4;

// GSM/2G Cell Information  
pub const LOG_GSM_L1_BURST_METRICS: u32 = 0x5134;
pub const LOG_GSM_L1_SCELL_BA_LIST: u32 = 0x5135;
pub const LOG_GSM_L1_NCELL_ACQ: u32 = 0x5136;
pub const LOG_GSM_L1_NCELL_BA_LIST: u32 = 0x5137;
pub const LOG_GSM_CELL_OPTIONS: u32 = 0x5138;
pub const LOG_GSM_POWER_SCAN: u32 = 0x5139;
pub const LOG_GSM_L1_CELL_ID: u32 = 0x513a;
pub const LOG_GSM_RR_CELL_INFORMATION: u32 = 0x513b;

// WCDMA/3G Cell Information
pub const LOG_WCDMA_CELL_ID: u32 = 0x4127;
pub const LOG_WCDMA_RRC_STATES: u32 = 0x4128;
pub const LOG_WCDMA_PLMN_SEARCH: u32 = 0x4129;
pub const LOG_WCDMA_SERVING_CELL_INFO: u32 = 0x412a;
pub const LOG_WCDMA_NEIGHBOR_CELL_INFO: u32 = 0x412b;

// Measurement Reports and Cell Quality
pub const LOG_LTE_PHY_SERV_CELL_MEASUREMENT: u32 = 0xb0f0;
pub const LOG_LTE_PHY_NEIGH_CELL_MEASUREMENT: u32 = 0xb0f1;
pub const LOG_LTE_PHY_INTER_FREQ_MEAS: u32 = 0xb0f2;
pub const LOG_LTE_PHY_INTER_RAT_MEAS: u32 = 0xb0f3;

// Location Area and Tracking Area Information
pub const LOG_LTE_EMM_OTA_INCOMING_MSG: u32 = 0xb0ec;
pub const LOG_LTE_EMM_OTA_OUTGOING_MSG: u32 = 0xb0ed;
pub const LOG_LTE_NAS_EMM_STATE: u32 = 0xb0ee;
pub const LOG_LTE_NAS_ESM_STATE: u32 = 0xb0ef;

// Additional Network Selection and Registration
pub const LOG_NAS_MANUAL_PLMN_SELECTION: u32 = 0x713f;
pub const LOG_NAS_ATTACH_REQUEST: u32 = 0x7140;
pub const LOG_NAS_ATTACH_ACCEPT: u32 = 0x7141;
pub const LOG_NAS_LOCATION_UPDATE: u32 = 0x7142;
pub const LOG_NAS_ROUTING_AREA_UPDATE: u32 = 0x7143;
pub const LOG_NAS_TRACKING_AREA_UPDATE: u32 = 0x7144;
