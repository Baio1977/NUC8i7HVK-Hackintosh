DefinitionBlock ("", "SSDT", 2, "Hack", "NUC8i7HV", 0x00000000)
{
    External (_PR_.PR00, ProcessorObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.XSTA, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
    External (_SB_.PCI0.PEG1, DeviceObj)
    External (_SB_.PCI0.PEG1.PEGP, DeviceObj)
    External (_SB_.PCI0.RP05, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX.TBDU.XHC_, DeviceObj)
    External (_SB_.PCI0.RP05.TBSE, FieldUnitObj)
    External (_SB_.PCI0.XHC_, DeviceObj)
    External (_SB_.PCI0.XHC_._PRW, MethodObj)    // 0 Arguments
    External (HPTE, IntObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            HPTE = Zero
        }

        Scope (_PR)
        {
            Scope (PR00)
            {
                If (_OSI ("Darwin"))
                {
                    Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                    {
                        If ((Arg2 == Zero))
                        {
                            Return (Buffer (One)
                            {
                                 0x03                                             // .
                            })
                        }

                        Return (Package (0x02)
                        {
                            "plugin-type", 
                            One
                        })
                    }
                }
            }
        }

        Scope (_SB)
        {
            Scope (PCI0)
            {
                Device (GAUS)
                {
                    Name (_ADR, 0x00080000)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }
                }

                Scope (LPCB)
                {
                    Device (DMAC)
                    {
                        Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            IO (Decode16,
                                0x0081,             // Range Minimum
                                0x0081,             // Range Maximum
                                0x01,               // Alignment
                                0x11,               // Length
                                )
                            IO (Decode16,
                                0x0093,             // Range Minimum
                                0x0093,             // Range Maximum
                                0x01,               // Alignment
                                0x0D,               // Length
                                )
                            IO (Decode16,
                                0x00C0,             // Range Minimum
                                0x00C0,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            DMA (Compatibility, NotBusMaster, Transfer8_16, )
                                {4}
                        })
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            If (_OSI ("Darwin"))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                    }

                    Scope (H_EC)
                    {
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            If (_OSI ("Darwin"))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (\_SB.PCI0.LPCB.H_EC.XSTA ())
                            }
                        }
                    }

                    Device (EC)
                    {
                        Name (_HID, "ACID0001")  // _HID: Hardware ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            If (_OSI ("Darwin"))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                    }
                }

                Device (MCHC)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }
                }

                Scope (PEG0)
                {
                    Scope (PEGP)
                    {
                        OperationRegion (PXCS, PCI_Config, Zero, 0x04)
                        Field (PXCS, AnyAcc, NoLock, Preserve)
                        {
                            VDID,   32
                        }

                        Method (MODL, 0, Serialized)
                        {
                            Switch (ToInteger (VDID))
                            {
                                Case (0x694C1002)
                                {
                                    Return (Buffer (0x18)
                                    {
                                        "AMD Radeon RX Vega M GH"
                                    })
                                }
                                Case (0x694E1002)
                                {
                                    Return (Buffer (0x18)
                                    {
                                        "AMD Radeon RX Vega M GL"
                                    })
                                }
                                Case (0x694F1002)
                                {
                                    Return (Buffer (0x1C)
                                    {
                                        "AMD Radeon Pro WX Vega M GL"
                                    })
                                }
                                Default
                                {
                                    Return (Buffer (0x08)
                                    {
                                        "Unknown"
                                    })
                                }

                            }
                        }
                    }
                }

                Scope (PEG1)
                {
                    Scope (PEGP)
                    {
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            If (_OSI ("Darwin"))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x0F)
                            }
                        }
                    }
                }

                If (_OSI ("Darwin"))
                {
                    Scope (RP05)
                    {
                        Name (PXSX._STA, Zero)  // _STA: Status
                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                        {
                            Return (Zero)
                        }

                        Device (UPSB)
                        {
                            Name (TUSB, Package (0x02)
                            {
                                One, 
                                0x02
                            })
                            Name (_ADR, Zero)  // _ADR: Address
                            OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                            Field (A1E0, ByteAcc, NoLock, Preserve)
                            {
                                AVND,   32, 
                                BMIE,   3, 
                                Offset (0x18), 
                                PRIB,   8, 
                                SECB,   8, 
                                SUBB,   8, 
                                Offset (0x1E), 
                                    ,   13, 
                                MABT,   1
                            }

                            Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                            {
                                Return (SECB) /* \_SB_.PCI0.RP05.UPSB.SECB */
                            }

                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                Return (Zero)
                            }

                            Device (DSB0)
                            {
                                Name (_ADR, Zero)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB0.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    Return (Zero)
                                }

                                Device (NHI0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Name (_STR, Unicode ("Thunderbolt"))  // _STR: Description String
                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        Return (Zero)
                                    }
                                }
                            }

                            Device (DSB1)
                            {
                                Name (_ADR, 0x00010000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                                Field (A1E1, ByteAcc, NoLock, Preserve)
                                {
                                    Offset (0x01), 
                                    Offset (0x02), 
                                    Offset (0x04), 
                                    Offset (0x08), 
                                    Offset (0x0A), 
                                        ,   5, 
                                    TPEN,   1, 
                                    Offset (0x0C), 
                                    SSPD,   4, 
                                        ,   16, 
                                    LACR,   1, 
                                    Offset (0x10), 
                                        ,   4, 
                                    LDIS,   1, 
                                    LRTN,   1, 
                                    Offset (0x12), 
                                    CSPD,   4, 
                                    CWDT,   6, 
                                        ,   1, 
                                    LTRN,   1, 
                                        ,   1, 
                                    LACT,   1, 
                                    Offset (0x14), 
                                    Offset (0x30), 
                                    TSPD,   4
                                }

                                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                                Field (A1E2, ByteAcc, NoLock, Preserve)
                                {
                                    Offset (0x01), 
                                    Offset (0x02), 
                                    Offset (0x04), 
                                    PSTA,   2
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    Return (Zero)
                                }

                                Device (UPS0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                    Field (ARE0, ByteAcc, NoLock, Preserve)
                                    {
                                        AVND,   16
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        Return (One)
                                    }

                                    Device (DSB0)
                                    {
                                        Name (_ADR, Zero)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1, 
                                            Offset (0x3E), 
                                                ,   6, 
                                            SBRS,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB0.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (DEV0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            Method (_STA, 0, NotSerialized)  // _STA: Status
                                            {
                                                Return (0x0F)
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }
                                        }
                                    }

                                    Device (DSB3)
                                    {
                                        Name (_ADR, 0x00030000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (UPS0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                            Field (ARE0, ByteAcc, NoLock, Preserve)
                                            {
                                                AVND,   16
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }

                                            Device (DSB0)
                                            {
                                                Name (_ADR, Zero)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1, 
                                                    Offset (0x3E), 
                                                        ,   6, 
                                                    SBRS,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.UPS0.DSB0.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }
                                                }
                                            }

                                            Device (DSB3)
                                            {
                                                Name (_ADR, 0x00030000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.UPS0.DSB3.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB4)
                                            {
                                                Name (_ADR, 0x00040000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.UPS0.DSB4.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB5)
                                            {
                                                Name (_ADR, 0x00050000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.UPS0.DSB5.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }

                                            Device (DSB6)
                                            {
                                                Name (_ADR, 0x00060000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB3.UPS0.DSB6.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }
                                        }
                                    }

                                    Device (DSB4)
                                    {
                                        Name (_ADR, 0x00040000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (UPS0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                            Field (ARE0, ByteAcc, NoLock, Preserve)
                                            {
                                                AVND,   16
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }

                                            Device (DSB0)
                                            {
                                                Name (_ADR, Zero)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1, 
                                                    Offset (0x3E), 
                                                        ,   6, 
                                                    SBRS,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.UPS0.DSB0.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB3)
                                            {
                                                Name (_ADR, 0x00030000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.UPS0.DSB3.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB4)
                                            {
                                                Name (_ADR, 0x00040000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.UPS0.DSB4.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB5)
                                            {
                                                Name (_ADR, 0x00050000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.UPS0.DSB5.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }

                                            Device (DSB6)
                                            {
                                                Name (_ADR, 0x00060000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB4.UPS0.DSB6.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }
                                        }
                                    }

                                    Device (DSB5)
                                    {
                                        Name (_ADR, 0x00050000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB5.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }
                                    }

                                    Device (DSB6)
                                    {
                                        Name (_ADR, 0x00060000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB1.UPS0.DSB6.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }
                                    }
                                }
                            }

                            Device (DSB2)
                            {
                                Name (_ADR, 0x00020000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB2.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    Return (Zero)
                                }

                                Device (XHC2)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    Device (RHUB)
                                    {
                                        Name (_ADR, Zero)  // _ADR: Address
                                        Method (TPLD, 2, Serialized)
                                        {
                                            Name (PCKG, Package (0x01)
                                            {
                                                Buffer (0x10){}
                                            })
                                            CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
                                            REV = One
                                            CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
                                            VISI = Arg0
                                            CreateField (DerefOf (PCKG [Zero]), 0x57, 0x08, GPOS)
                                            GPOS = Arg1
                                            CreateField (DerefOf (PCKG [Zero]), 0x4A, 0x04, SHAP)
                                            SHAP = One
                                            CreateField (DerefOf (PCKG [Zero]), 0x20, 0x10, WID)
                                            WID = 0x08
                                            CreateField (DerefOf (PCKG [Zero]), 0x30, 0x10, HGT)
                                            HGT = 0x03
                                            Return (PCKG) /* \_SB_.PCI0.RP05.UPSB.DSB2.XHC2.RHUB.TPLD.PCKG */
                                        }

                                        Method (TUPC, 2, Serialized)
                                        {
                                            Name (PCKG, Package (0x04)
                                            {
                                                One, 
                                                Zero, 
                                                Zero, 
                                                Zero
                                            })
                                            PCKG [Zero] = Arg0
                                            PCKG [One] = Arg1
                                            Return (PCKG) /* \_SB_.PCI0.RP05.UPSB.DSB2.XHC2.RHUB.TUPC.PCKG */
                                        }

                                        Device (SS01)
                                        {
                                            Name (_ADR, 0x03)  // _ADR: Address
                                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                                            {
                                                Return (TUPC (One, 0x0A))
                                            }

                                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                                            {
                                                Return (TPLD (One, 0x0C))
                                            }
                                        }

                                        Device (SS02)
                                        {
                                            Name (_ADR, 0x04)  // _ADR: Address
                                            Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                                            {
                                                Return (TUPC (One, 0x0A))
                                            }

                                            Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                                            {
                                                Return (TPLD (One, 0x0D))
                                            }
                                        }
                                    }
                                }
                            }

                            Device (DSB4)
                            {
                                Name (_ADR, 0x00040000)  // _ADR: Address
                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                {
                                    AVND,   32, 
                                    BMIE,   3, 
                                    Offset (0x18), 
                                    PRIB,   8, 
                                    SECB,   8, 
                                    SUBB,   8, 
                                    Offset (0x1E), 
                                        ,   13, 
                                    MABT,   1
                                }

                                OperationRegion (A1E1, PCI_Config, 0xC0, 0x40)
                                Field (A1E1, ByteAcc, NoLock, Preserve)
                                {
                                    Offset (0x01), 
                                    Offset (0x02), 
                                    Offset (0x04), 
                                    Offset (0x08), 
                                    Offset (0x0A), 
                                        ,   5, 
                                    TPEN,   1, 
                                    Offset (0x0C), 
                                    SSPD,   4, 
                                        ,   16, 
                                    LACR,   1, 
                                    Offset (0x10), 
                                        ,   4, 
                                    LDIS,   1, 
                                    LRTN,   1, 
                                    Offset (0x12), 
                                    CSPD,   4, 
                                    CWDT,   6, 
                                        ,   1, 
                                    LTRN,   1, 
                                        ,   1, 
                                    LACT,   1, 
                                    Offset (0x14), 
                                    Offset (0x30), 
                                    TSPD,   4
                                }

                                OperationRegion (A1E2, PCI_Config, 0x80, 0x08)
                                Field (A1E2, ByteAcc, NoLock, Preserve)
                                {
                                    Offset (0x01), 
                                    Offset (0x02), 
                                    Offset (0x04), 
                                    PSTA,   2
                                }

                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                {
                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.SECB */
                                }

                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                {
                                    Return (0x0F)
                                }

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    Return (Zero)
                                }

                                Device (UPS0)
                                {
                                    Name (_ADR, Zero)  // _ADR: Address
                                    OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                    Field (ARE0, ByteAcc, NoLock, Preserve)
                                    {
                                        AVND,   16
                                    }

                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                    {
                                        Return (One)
                                    }

                                    Device (DSB0)
                                    {
                                        Name (_ADR, Zero)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1, 
                                            Offset (0x3E), 
                                                ,   6, 
                                            SBRS,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB0.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (DEV0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            Method (_STA, 0, NotSerialized)  // _STA: Status
                                            {
                                                Return (0x0F)
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }
                                        }
                                    }

                                    Device (DSB3)
                                    {
                                        Name (_ADR, 0x00030000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (UPS0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                            Field (ARE0, ByteAcc, NoLock, Preserve)
                                            {
                                                AVND,   16
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }

                                            Device (DSB0)
                                            {
                                                Name (_ADR, Zero)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1, 
                                                    Offset (0x3E), 
                                                        ,   6, 
                                                    SBRS,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.UPS0.DSB0.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }
                                                }
                                            }

                                            Device (DSB3)
                                            {
                                                Name (_ADR, 0x00030000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.UPS0.DSB3.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB4)
                                            {
                                                Name (_ADR, 0x00040000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.UPS0.DSB4.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB5)
                                            {
                                                Name (_ADR, 0x00050000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.UPS0.DSB5.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }

                                            Device (DSB6)
                                            {
                                                Name (_ADR, 0x00060000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB3.UPS0.DSB6.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }
                                        }
                                    }

                                    Device (DSB4)
                                    {
                                        Name (_ADR, 0x00040000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }

                                        Device (UPS0)
                                        {
                                            Name (_ADR, Zero)  // _ADR: Address
                                            OperationRegion (ARE0, PCI_Config, Zero, 0x04)
                                            Field (ARE0, ByteAcc, NoLock, Preserve)
                                            {
                                                AVND,   16
                                            }

                                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                            {
                                                Return (One)
                                            }

                                            Device (DSB0)
                                            {
                                                Name (_ADR, Zero)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1, 
                                                    Offset (0x3E), 
                                                        ,   6, 
                                                    SBRS,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.UPS0.DSB0.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB3)
                                            {
                                                Name (_ADR, 0x00030000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.UPS0.DSB3.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB4)
                                            {
                                                Name (_ADR, 0x00040000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.UPS0.DSB4.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }

                                                Device (DEV0)
                                                {
                                                    Name (_ADR, Zero)  // _ADR: Address
                                                    Method (_STA, 0, NotSerialized)  // _STA: Status
                                                    {
                                                        Return (0x0F)
                                                    }

                                                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                    {
                                                        Return (One)
                                                    }
                                                }
                                            }

                                            Device (DSB5)
                                            {
                                                Name (_ADR, 0x00050000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.UPS0.DSB5.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }

                                            Device (DSB6)
                                            {
                                                Name (_ADR, 0x00060000)  // _ADR: Address
                                                OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                                Field (A1E0, ByteAcc, NoLock, Preserve)
                                                {
                                                    AVND,   32, 
                                                    BMIE,   3, 
                                                    Offset (0x18), 
                                                    PRIB,   8, 
                                                    SECB,   8, 
                                                    SUBB,   8, 
                                                    Offset (0x1E), 
                                                        ,   13, 
                                                    MABT,   1
                                                }

                                                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                                {
                                                    Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB4.UPS0.DSB6.SECB */
                                                }

                                                Method (_STA, 0, NotSerialized)  // _STA: Status
                                                {
                                                    Return (0x0F)
                                                }

                                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                                {
                                                    Return (One)
                                                }
                                            }
                                        }
                                    }

                                    Device (DSB5)
                                    {
                                        Name (_ADR, 0x00050000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB5.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }
                                    }

                                    Device (DSB6)
                                    {
                                        Name (_ADR, 0x00060000)  // _ADR: Address
                                        OperationRegion (A1E0, PCI_Config, Zero, 0x40)
                                        Field (A1E0, ByteAcc, NoLock, Preserve)
                                        {
                                            AVND,   32, 
                                            BMIE,   3, 
                                            Offset (0x18), 
                                            PRIB,   8, 
                                            SECB,   8, 
                                            SUBB,   8, 
                                            Offset (0x1E), 
                                                ,   13, 
                                            MABT,   1
                                        }

                                        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                                        {
                                            Return (SECB) /* \_SB_.PCI0.RP05.UPSB.DSB4.UPS0.DSB6.SECB */
                                        }

                                        Method (_STA, 0, NotSerialized)  // _STA: Status
                                        {
                                            Return (0x0F)
                                        }

                                        Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                        {
                                            Return (One)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Device (SRAM)
                {
                    Name (_ADR, 0x00140002)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }
                }
            }

            Device (USBX)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x08)
                    {
                        "kUSBSleepPowerSupply", 
                        0x0C80, 
                        "kUSBSleepPortCurrentLimit", 
                        0x0834, 
                        "kUSBWakePowerSupply", 
                        0x0C80, 
                        "kUSBWakePortCurrentLimit", 
                        0x0834
                    })
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If (_OSI ("Darwin"))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
            }

            If ((CondRefOf (\_OSI, Local0) && _OSI ("Darwin")))
            {
                Device (USBW)
                {
                    Name (_HID, "PNP0D10" /* XHCI USB Controller with debug */)  // _HID: Hardware ID
                    Name (_UID, "WAKE")  // _UID: Unique ID
                    Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                    {
                        Return (\_SB.PCI0.XHC._PRW ())
                    }
                }
            }
        }
    }
}

