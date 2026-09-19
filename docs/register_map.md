# APB-Based SPI Master Controller — Register Map

## 1. Overview

This document describes the APB-accessible register map implemented by `APB_SLAVE_INTERFACE.v`.

| Address | Register | Purpose |
|---:|---|---|
| `0x00` | `CR1` | Main SPI control/configuration |
| `0x01` | `CR2` | Additional SPI control |
| `0x02` | `BR` | Baud-rate configuration |
| `0x03` | `STATUS` | SPI status |
| `0x05` | `DR` | Transmit/receive data |

Addresses not listed above are not assigned to the documented registers in the current RTL.

---

# 2. CR1 — Control Register 1

**Address: `0x00`**

The RTL constructs CR1 using:

```verilog
{spie, spe, sptie, MSTR_O, CPOL_O, CPHA_O, ssoe, LSBFE_O}
```

## Bit Map

```text
  7       6       5       4       3       2       1       0
+-------+-------+-------+-------+-------+-------+-------+-------+
| SPIE  | SPE   | SPTIE | MSTR  | CPOL  | CPHA  | SSOE  | LSBFE |
+-------+-------+-------+-------+-------+-------+-------+-------+
```

| Bit | Field | Description |
|---:|---|---|
| 7 | `SPIE` | SPI interrupt enable |
| 6 | `SPE` | SPI enable |
| 5 | `SPTIE` | SPI transmit interrupt enable |
| 4 | `MSTR` | Master-mode control |
| 3 | `CPOL` | SPI clock polarity |
| 2 | `CPHA` | SPI clock phase |
| 1 | `SSOE` | Slave-select output enable/control field |
| 0 | `LSBFE` | LSB-first enable |

---

# 3. CR2 — Control Register 2

**Address: `0x01`**

The implemented CR2 mask is:

```verilog
8'b00011010
```

| Bit | Field | Description |
|---:|---|---|
| 4 | Mode-fault enable field | Controls the mode-fault related configuration implemented by the RTL |
| 1 | `SPISWAI` | SPI stop-in-wait control |
| Other | Reserved/unimplemented | Not used by the documented control logic |

`SPISWAI` is connected to the SPI timing/control logic and influences SPI clock activity in the relevant wait condition.

---

# 4. BR — Baud Rate Register

**Address: `0x02`**

The implemented BR mask is:

```verilog
8'b01110111
```

## Bit Map

```text
  7       6       5       4       3       2       1       0
+-------+-------+-------+-------+-------+-------+-------+-------+
|   -   | SPPR2 | SPPR1 | SPPR0 |   -   | SPR2  | SPR1  | SPR0  |
+-------+-------+-------+-------+-------+-------+-------+-------+
```

| Bits | Field | Description |
|---:|---|---|
| `[6:4]` | `SPPR` | SPI prescaler selection |
| `[2:0]` | `SPR` | SPI rate-selection field |
| `[7]` | Reserved | Not part of the baud field |
| `[3]` | Reserved | Not part of the baud field |

The APB interface exposes:

```verilog
SPR_O  = br_reg[2:0];
SPPR_O = br_reg[6:4];
```

---

# 5. Baud-Rate Calculation

The `BAUD_GENERATOR` uses:

```verilog
wire [3:0] baud_div_1 = (SPPR_I + 1);
wire [8:0] baud_div_2 = (1 << (SPR_I + 1));
```

Therefore:

```text
baud_div_1 = SPPR + 1
baud_div_2 = 2^(SPR + 1)

BAUD_RATE_DIV = baud_div_1 × baud_div_2
```

The resulting division value is used by the SPI clock-generation logic.

### Important synthesis detail

Because:

```text
2^(SPR + 1)
```

is always even:

```text
BAUD_RATE_DIV[0] = 0
```

for every legal `SPR` value.

This explains the synthesis/check-design messages concerning:

```text
BAUD_RATE_DIV_O[0]
BAUD_RATE_DIV_I[0]
```

The bit is redundant and can be optimized away.

---

# 6. STATUS — Status Register

**Address: `0x03`**

The RTL constructs the status value as:

```verilog
{spif_reg, 1'b0, sptef_reg, modf, 4'b0}
```

## Bit Map

```text
  7       6       5       4       3       2       1       0
+-------+-------+-------+-------+-------+-------+-------+-------+
| SPIF  |   0   | SPTEF | MODF  |   0   |   0   |   0   |   0   |
+-------+-------+-------+-------+-------+-------+-------+-------+
```

| Bit | Field | Description |
|---:|---|---|
| 7 | `SPIF` | SPI transfer-complete flag |
| 6 | Reserved | Reads as `0` |
| 5 | `SPTEF` | SPI transmit-data-register-empty flag |
| 4 | `MODF` | Mode-fault status |
| `[3:0]` | Reserved | Reads as `0` |

---

# 7. SPIF — SPI Transfer Complete

**Bit: `STATUS[7]`**

`SPIF` indicates that the SPI transfer has completed and receive data has become available according to the implemented control sequence.

The APB interface updates and clears this flag according to the RTL transfer/read logic.

---

# 8. SPTEF — SPI Transmit Empty

**Bit: `STATUS[5]`**

`SPTEF` represents the transmit-data-register empty condition.

The implemented flow uses internal `dr_pending` and `SEND_DATA_O` control:

```text
APB write to DR
      │
      ▼
TX data becomes pending
      │
      ▼
SPI transfer starts
      │
      ▼
SEND_DATA_O
      │
      ▼
TX data is consumed by SPI datapath
      │
      ▼
SPTEF is updated
```

The exact sequencing is controlled by the RTL.

---

# 9. MODF — Mode Fault

**Bit: `STATUS[4]`**

`MODF` is the mode-fault status field exposed by the APB status register.

The related configuration is available through CR2.

---

# 10. DR — Data Register

**Address: `0x05`**

The Data Register is used for SPI transmit and receive data.

The reported implementation uses:

```text
WIDTH = 8
```

so the active SPI data path is 8 bits.

## Write

An APB write to address `0x05` supplies transmit data:

```text
APB PWDATA
     │
     ▼
    DR
     │
     ▼
TX pending
     │
     ▼
SPI transfer
```

## Read

After the SPI transfer, received data is made available to the APB interface:

```text
MISO
  │
  ▼
SPI_SHIFT_REGISTER
  │
  ▼
Received parallel data
  │
  ▼
APB interface
  │
  ▼
PRDATA_O
```

---

# 11. Interrupt Request

The implemented interrupt expression is:

```verilog
(sptie && sptef_reg) ||
(spie && (spif_reg || modf))
```

Thus an interrupt request can be generated by:

```text
SPTIE AND SPTEF
```

or:

```text
SPIE AND (SPIF OR MODF)
```

The enable fields are located in CR1.

---

# 12. APB Transaction Handling

The APB interface implements:

```text
IDLE → SETUP → ENABLE
```

The RTL generates:

```text
PREADY_O = 1
```

when the APB FSM is in the `APB_ENABLE` state.

The implemented APB error condition is associated with:

```text
APB_ENABLE
AND
~SS_I
AND
PWRITE_I
```

---

# 13. Register Summary

| Address | Register | Key Fields |
|---:|---|---|
| `0x00` | `CR1` | SPIE, SPE, SPTIE, MSTR, CPOL, CPHA, SSOE, LSBFE |
| `0x01` | `CR2` | SPISWAI and mode-fault related control |
| `0x02` | `BR` | SPPR, SPR |
| `0x03` | `STATUS` | SPIF, SPTEF, MODF |
| `0x05` | `DR` | TX/RX data |

---

# 14. Typical Programming / Testbench Sequence

```text
1. Configure CR1
       │
       ├── Enable SPI
       ├── Select master mode
       ├── Configure CPOL/CPHA
       └── Configure bit order
       │
       ▼
2. Configure CR2
       │
       └── Configure additional SPI control
       │
       ▼
3. Configure BR
       │
       ├── SPPR
       └── SPR
       │
       ▼
4. Write TX data to DR
       │
       ▼
5. SPI transfer
       │
       ├── SS asserted
       ├── SCLK generated
       ├── MOSI shifted
       └── MISO sampled
       │
       ▼
6. Transfer completes
       │
       ▼
7. Receive data becomes available
       │
       ▼
8. Read DR
       │
       ▼
9. Received data returned through PRDATA
```

---

# 15. Current 8-bit Configuration

```text
WIDTH = 8

log2(WIDTH) = log2(8) = 3
```

The transfer-control block uses the width-dependent logarithmic factor together with the baud-division value in its transfer-count calculation.

---

# 16. Source of Truth

This register map is based on:

```text
rtl/APB_SLAVE_INTERFACE.v
rtl/BAUD_GENERATOR.v
rtl/SPI_SHIFT_REGISTER.v
rtl/SPI_SLAVE_CONTROL_SELECT.v
rtl/SPI_TOP.v
```

The RTL is the authoritative source for the exact behavior of the current implementation.

If a future RTL revision changes a register field or its behavior, this document should be updated accordingly.
