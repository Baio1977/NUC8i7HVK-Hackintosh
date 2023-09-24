
DefinitionBlock ("", "SSDT", 2, "Hack", "HotPlug", 0x00000000)
{
    External (_GPE.TBFF, MethodObj)    // 1 Arguments
    External (_GPE.TFPS, MethodObj)    // 0 Arguments
    External (_GPE.XTBT, MethodObj)    // 2 Arguments
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GPCB, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.RP05, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX, DeviceObj)
    External (_SB_.PCI0.RP05.PXSX.AVND, IntObj)
    External (_SB_.PCI0.RP05.PXSX.TBDU, DeviceObj)
    External (_SB_.PCI0.RP05.XINI, MethodObj)    // 0 Arguments
    External (_SB_.TBFP, MethodObj)    // 1 Arguments
    External (CPGN, FieldUnitObj)
    External (FFTB, MethodObj)    // 1 Arguments
    External (MMRP, MethodObj)    // 1 Arguments
    External (MMTB, MethodObj)    // 1 Arguments
    External (OSUM, MutexObj)
    External (SOHP, FieldUnitObj)
    External (TBSE, FieldUnitObj)
    External (TNAT, FieldUnitObj)
    External (TWIN, FieldUnitObj)

    Scope (\)
    {
        Scope (_GPE)
        {
            Method (_E20, 0, NotSerialized)  // _Exx: Edge-Triggered GPE, xx=0x00-0xFF
            {
                \_SB.PCI0.RP05.DBG1 ("_E20")
                \_GPE.XTBT (TBSE, CPGN)
                \_SB.PCI0.RP05.DBG1 ("End-of-_E20")
            }
        }

        Device (RMDT)
        {
            Name (_HID, "RMD0000")  // _HID: Hardware ID
            Name (RING, Package (0x0100){})
            Mutex (RTMX, 0x00)
            Name (HEAD, Zero)
            Name (TAIL, Zero)
            Method (PUSH, 1, NotSerialized)
            {
                Acquire (RTMX, 0xFFFF)
                Local0 = (HEAD + One)
                If ((Local0 >= SizeOf (RING)))
                {
                    Local0 = Zero
                }

                If ((Local0 != TAIL))
                {
                    RING [HEAD] = Arg0
                    HEAD = Local0
                }

                Release (RTMX)
                Notify (RMDT, 0x80) // Status Change
            }

            Method (FTCH, 0, NotSerialized)
            {
                Acquire (RTMX, 0xFFFF)
                Local0 = Zero
                If ((HEAD != TAIL))
                {
                    Local0 = DerefOf (RING [TAIL])
                    TAIL++
                    If ((TAIL >= SizeOf (RING)))
                    {
                        TAIL = Zero
                    }
                }

                Release (RTMX)
                Return (Local0)
            }

            Method (COUN, 0, NotSerialized)
            {
                Acquire (RTMX, 0xFFFF)
                Local0 = (HEAD - TAIL) /* \RMDT.TAIL */
                If ((Local0 < Zero))
                {
                    Local0 += SizeOf (RING)
                }

                Release (RTMX)
                Return (Local0)
            }

            Method (P1, 1, NotSerialized)
            {
                PUSH (Arg0)
            }

            Method (P2, 2, Serialized)
            {
                Name (TEMP, Package (0x02){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                PUSH (TEMP)
            }

            Method (P3, 3, Serialized)
            {
                Name (TEMP, Package (0x03){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                TEMP [0x02] = Arg2
                PUSH (TEMP)
            }

            Method (P4, 4, Serialized)
            {
                Name (TEMP, Package (0x04){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                TEMP [0x02] = Arg2
                TEMP [0x03] = Arg3
                PUSH (TEMP)
            }

            Method (P5, 5, Serialized)
            {
                Name (TEMP, Package (0x05){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                TEMP [0x02] = Arg2
                TEMP [0x03] = Arg3
                TEMP [0x04] = Arg4
                PUSH (TEMP)
            }

            Method (P6, 6, Serialized)
            {
                Name (TEMP, Package (0x06){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                TEMP [0x02] = Arg2
                TEMP [0x03] = Arg3
                TEMP [0x04] = Arg4
                TEMP [0x05] = Arg5
                PUSH (TEMP)
            }

            Method (P7, 7, Serialized)
            {
                Name (TEMP, Package (0x07){})
                TEMP [Zero] = Arg0
                TEMP [One] = Arg1
                TEMP [0x02] = Arg2
                TEMP [0x03] = Arg3
                TEMP [0x04] = Arg4
                TEMP [0x05] = Arg5
                TEMP [0x06] = Arg6
                PUSH (TEMP)
            }
        }

        Scope (_SB)
        {
            Scope (PCI0)
            {
                Scope (RP05)
                {
                    Method (DBG1, 1, NotSerialized)
                    {
                        If (CondRefOf (\RMDT.P1))
                        {
                            \RMDT.P1 (Arg0)
                        }
                    }

                    Method (DBG2, 2, NotSerialized)
                    {
                        If (CondRefOf (\RMDT.P2))
                        {
                            \RMDT.P2 (Arg0, Arg1)
                        }
                    }

                    Method (DBG3, 3, NotSerialized)
                    {
                        If (CondRefOf (\RMDT.P3))
                        {
                            \RMDT.P3 (Arg0, Arg1, Arg2)
                        }
                    }

                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (Zero)
                    }

                    If (_OSI ("Darwin"))
                    {
                        Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                        {
                            TBON ()
                        }

                        Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                        {
                            TBOF ()
                        }
                    }

                    Method (TBON, 0, Serialized)
                    {
                        DBG1 ("TBON")
                        If (\_GPE.TFPS ())
                        {
                            DBG1 ("Already on")
                            Return (Zero)
                        }

                        TWIN = Zero
                        TBFP (One)
                        DBG1 ("Wait for TB root power up")
                        Local1 = (Timer + 0x005B8D80)
                        While (((Timer < Local1) && FFTB (TBSE)))
                        {
                            Sleep (One)
                        }

                        DBG1 ("Sending OSUP handshake")
                        Acquire (OSUM, 0xFFFF)
                        Local0 = \_GPE.TBFF (TBSE)
                        Release (OSUM)
                        DBG2 ("TBFF", Local0)
                        DBG1 ("TB hardware init sequence")
                        SOHP = Zero
                        TNAT = One
                        \_GPE.XTBT (TBSE, CPGN)
                        DBG1 ("Waiting for controller to appear")
                        OperationRegion (UPS0, SystemMemory, MMTB (TBSE), 0x04)
                        Field (UPS0, DWordAcc, NoLock, Preserve)
                        {
                            UPV0,   32
                        }

                        Local1 = (Timer + 0x02FAF080)
                        While (((Timer < Local1) && (UPV0 == 0xFFFFFFFF)))
                        {
                            Sleep (0x64)
                        }

                        If ((UPV0 != 0xFFFFFFFF))
                        {
                            DBG2 ("Seen controller", UPV0)
                            Return (One)
                        }
                        Else
                        {
                            DBG1 ("Failed")
                            Return (Zero)
                        }
                    }

                    Method (TBOF, 0, Serialized)
                    {
                        DBG1 ("TBOF")
                        If (\_GPE.TFPS ())
                        {
                            TBFP (Zero)
                            Return (One)
                        }
                        Else
                        {
                            DBG1 ("Already off")
                            Return (Zero)
                        }
                    }

                    Name (EICM, Zero)
                    Name (R020, Zero)
                    Name (R024, Zero)
                    Name (R118, Zero)
                    Name (R119, Zero)
                    Name (R11A, Zero)
                    Name (R11C, Zero)
                    Name (R120, Zero)
                    Name (R124, Zero)
                    Name (R218, Zero)
                    Name (R219, Zero)
                    Name (R21A, Zero)
                    Name (R21C, Zero)
                    Name (R220, Zero)
                    Name (R224, Zero)
                    Name (R318, Zero)
                    Name (R319, Zero)
                    Name (R31A, Zero)
                    Name (R31C, Zero)
                    Name (R320, Zero)
                    Name (R324, Zero)
                    Name (R418, Zero)
                    Name (R419, Zero)
                    Name (R41A, Zero)
                    Name (R41C, Zero)
                    Name (R420, Zero)
                    Name (R424, Zero)
                    Name (RVES, Zero)
                    Name (R518, Zero)
                    Name (R519, Zero)
                    Name (R51A, Zero)
                    Name (R51C, Zero)
                    Name (R520, Zero)
                    Name (R524, Zero)
                    Name (R618, Zero)
                    Name (R619, Zero)
                    Name (R61A, Zero)
                    Name (R61C, Zero)
                    Name (R620, Zero)
                    Name (R624, Zero)
                    Name (RH10, Zero)
                    Name (RH14, Zero)
                    Name (POC0, Zero)
                    Method (MMIO, 3, NotSerialized)
                    {
                        Local0 = \_SB.PCI0.GPCB ()
                        Local0 += (Arg0 << 0x14)
                        Local0 += (Arg1 << 0x0F)
                        Local0 += (Arg2 << 0x0C)
                        Return (Local0)
                    }

                    OperationRegion (RPSM, SystemMemory, MMRP (TBSE), 0x54)
                    Field (RPSM, DWordAcc, NoLock, Preserve)
                    {
                        RPVD,   32, 
                        RPR4,   8, 
                        Offset (0x18), 
                        RP18,   8, 
                        RP19,   8, 
                        RP1A,   8, 
                        Offset (0x1C), 
                        RP1C,   16, 
                        Offset (0x20), 
                        R_20,   32, 
                        R_24,   32, 
                        Offset (0x52), 
                            ,   11, 
                        RPLT,   1, 
                        Offset (0x54)
                    }

                    OperationRegion (UPSM, SystemMemory, MMTB (TBSE), 0x0550)
                    Field (UPSM, DWordAcc, NoLock, Preserve)
                    {
                        UPVD,   32, 
                        UP04,   8, 
                        Offset (0x08), 
                        CLRD,   32, 
                        Offset (0x18), 
                        UP18,   8, 
                        UP19,   8, 
                        UP1A,   8, 
                        Offset (0x1C), 
                        UP1C,   16, 
                        Offset (0x20), 
                        UP20,   32, 
                        UP24,   32, 
                        Offset (0xD2), 
                            ,   11, 
                        UPLT,   1, 
                        Offset (0xD4), 
                        Offset (0x544), 
                        UPMB,   1, 
                        Offset (0x548), 
                        T2PR,   32, 
                        P2TR,   32
                    }

                    OperationRegion (DNSM, SystemMemory, MMIO ((RP19 + One), Zero, Zero), 0xD4)
                    Field (DNSM, DWordAcc, NoLock, Preserve)
                    {
                        DPVD,   32, 
                        DP04,   8, 
                        Offset (0x18), 
                        DP18,   8, 
                        DP19,   8, 
                        DP1A,   8, 
                        Offset (0x1C), 
                        DP1C,   16, 
                        Offset (0x20), 
                        DP20,   32, 
                        DP24,   32, 
                        Offset (0xD2), 
                            ,   11, 
                        DPLT,   1, 
                        Offset (0xD4)
                    }

                    OperationRegion (DS3M, SystemMemory, MMIO ((RP19 + One), One, Zero), 0x40)
                    Field (DS3M, DWordAcc, NoLock, Preserve)
                    {
                        D3VD,   32, 
                        D304,   8, 
                        Offset (0x18), 
                        D318,   8, 
                        D319,   8, 
                        D31A,   8, 
                        Offset (0x1C), 
                        D31C,   16, 
                        Offset (0x20), 
                        D320,   32, 
                        D324,   32
                    }

                    OperationRegion (DS4M, SystemMemory, MMIO ((RP19 + One), 0x02, Zero), 0x0568)
                    Field (DS4M, DWordAcc, NoLock, Preserve)
                    {
                        D4VD,   32, 
                        D404,   8, 
                        Offset (0x18), 
                        D418,   8, 
                        D419,   8, 
                        D41A,   8, 
                        Offset (0x1C), 
                        D41C,   16, 
                        Offset (0x20), 
                        D420,   32, 
                        D424,   32, 
                        Offset (0x564), 
                        DVES,   32
                    }

                    OperationRegion (DS5M, SystemMemory, MMIO ((RP19 + One), 0x04, Zero), 0x40)
                    Field (DS5M, DWordAcc, NoLock, Preserve)
                    {
                        D5VD,   32, 
                        D504,   8, 
                        Offset (0x18), 
                        D518,   8, 
                        D519,   8, 
                        D51A,   8, 
                        Offset (0x1C), 
                        D51C,   16, 
                        Offset (0x20), 
                        D520,   32, 
                        D524,   32
                    }

                    OperationRegion (NHIM, SystemMemory, MMIO ((RP19 + 0x02), Zero, Zero), 0x40)
                    Field (NHIM, DWordAcc, NoLock, Preserve)
                    {
                        NH00,   32, 
                        NH04,   8, 
                        Offset (0x10), 
                        NH10,   32, 
                        NH14,   32
                    }

                    OperationRegion (RSTR, SystemMemory, ((((R_20 & 0xFFFC) << 0x10) & 0xFFF00000) + 
                        0x00039854), 0x0100)
                    Field (RSTR, DWordAcc, NoLock, Preserve)
                    {
                        CIOR,   32, 
                        Offset (0xB8), 
                        ISTA,   32, 
                        Offset (0xF0), 
                        ICME,   32
                    }

                    OperationRegion (XHCM, SystemMemory, MMIO ((RP19 + 0x04), Zero, Zero), 0x40)
                    Field (XHCM, DWordAcc, NoLock, Preserve)
                    {
                        XH00,   32, 
                        XH04,   8, 
                        Offset (0x10), 
                        XH10,   32, 
                        XH14,   32
                    }

                    Method (_INI, 0, NotSerialized)  // _INI: Initialize
                    {
                        If (_OSI ("Darwin"))
                        {
                            DBG3 ("RP", RPVD, R_20)
                            R020 = R_20 /* \_SB_.PCI0.RP05.R_20 */
                            R024 = R_24 /* \_SB_.PCI0.RP05.R_24 */
                            R118 = RP19 /* \_SB_.PCI0.RP05.RP19 */
                            R119 = (RP19 + One)
                            R11A = RP1A /* \_SB_.PCI0.RP05.RP1A */
                            R11C = RP1C /* \_SB_.PCI0.RP05.RP1C */
                            R120 = R_20 /* \_SB_.PCI0.RP05.R_20 */
                            R124 = R_24 /* \_SB_.PCI0.RP05.R_24 */
                            R218 = R119 /* \_SB_.PCI0.RP05.R119 */
                            R219 = (R119 + One)
                            R21A = R11A /* \_SB_.PCI0.RP05.R11A */
                            R21C = R11C /* \_SB_.PCI0.RP05.R11C */
                            R220 = R120 /* \_SB_.PCI0.RP05.R120 */
                            R224 = R124 /* \_SB_.PCI0.RP05.R124 */
                            R318 = R119 /* \_SB_.PCI0.RP05.R119 */
                            R319 = (R119 + 0x02)
                            R31A = (R119 + 0x02)
                            R31C = Zero
                            R320 = Zero
                            R324 = Zero
                            R418 = R119 /* \_SB_.PCI0.RP05.R119 */
                            R419 = (R119 + 0x03)
                            R41A = (R119 + 0x03)
                            R41C = Zero
                            R420 = Zero
                            R424 = Zero
                            RVES = Zero
                            R518 = R119 /* \_SB_.PCI0.RP05.R119 */
                            R519 = (R119 + 0x04)
                            R51A = (R119 + 0x04)
                            R51C = Zero
                            R520 = Zero
                            R524 = Zero
                            R618 = Zero
                            R619 = Zero
                            R61A = Zero
                            R61C = Zero
                            R620 = Zero
                            R624 = Zero
                            RH10 = ((R220 & 0xFFFC) << 0x10)
                            RH14 = Zero
                            Sleep (One)
                            TBON ()
                            ICMS ()
                        }
                        Else
                        {
                            XINI ()
                        }
                    }

                    Method (ICMS, 0, NotSerialized)
                    {
                        \_SB.PCI0.RP05.POC0 = One
                        DBG2 ("ICME", \_SB.PCI0.RP05.ICME)
                        If ((\_SB.PCI0.RP05.ICME != 0x800001A3))
                        {
                            If (\_SB.PCI0.RP05.CNHI ())
                            {
                                DBG2 ("ICME", \_SB.PCI0.RP05.ICME)
                                If ((\_SB.PCI0.RP05.ICME != 0xFFFFFFFF))
                                {
                                    \_SB.PCI0.RP05.WTLT ()
                                    DBG2 ("ICME", \_SB.PCI0.RP05.ICME)
                                }
                            }
                        }

                        \_SB.PCI0.RP05.POC0 = Zero
                    }

                    Method (CNHI, 0, Serialized)
                    {
                        Local0 = 0x0A
                        DBG1 ("Configure root")
                        While (Local0)
                        {
                            R_20 = R020 /* \_SB_.PCI0.RP05.R020 */
                            R_24 = R024 /* \_SB_.PCI0.RP05.R024 */
                            RPR4 = 0x07
                            If ((R020 == R_20))
                            {
                                Break
                            }

                            Sleep (One)
                            Local0--
                        }

                        If ((R020 != R_20))
                        {
                            Return (Zero)
                        }

                        DBG1 ("Configure UPSB")
                        Local0 = 0x0A
                        While (Local0)
                        {
                            UP18 = R118 /* \_SB_.PCI0.RP05.R118 */
                            UP19 = R119 /* \_SB_.PCI0.RP05.R119 */
                            UP1A = R11A /* \_SB_.PCI0.RP05.R11A */
                            UP1C = R11C /* \_SB_.PCI0.RP05.R11C */
                            UP20 = R120 /* \_SB_.PCI0.RP05.R120 */
                            UP24 = R124 /* \_SB_.PCI0.RP05.R124 */
                            UP04 = 0x07
                            If ((R119 == UP19))
                            {
                                Break
                            }

                            Sleep (One)
                            Local0--
                        }

                        If ((R119 != UP19))
                        {
                            Return (Zero)
                        }

                        DBG1 ("Wait for link training")
                        If ((WTLT () != One))
                        {
                            Return (Zero)
                        }

                        DBG1 ("Configure DSB")
                        Local0 = 0x0A
                        While (Local0)
                        {
                            DP18 = R218 /* \_SB_.PCI0.RP05.R218 */
                            DP19 = R219 /* \_SB_.PCI0.RP05.R219 */
                            DP1A = R21A /* \_SB_.PCI0.RP05.R21A */
                            DP1C = R21C /* \_SB_.PCI0.RP05.R21C */
                            DP20 = R220 /* \_SB_.PCI0.RP05.R220 */
                            DP24 = R224 /* \_SB_.PCI0.RP05.R224 */
                            DP04 = 0x07
                            D318 = R318 /* \_SB_.PCI0.RP05.R318 */
                            D319 = R319 /* \_SB_.PCI0.RP05.R319 */
                            D31A = R31A /* \_SB_.PCI0.RP05.R31A */
                            D31C = R31C /* \_SB_.PCI0.RP05.R31C */
                            D320 = R320 /* \_SB_.PCI0.RP05.R320 */
                            D324 = R324 /* \_SB_.PCI0.RP05.R324 */
                            D304 = 0x07
                            D418 = R418 /* \_SB_.PCI0.RP05.R418 */
                            D419 = R419 /* \_SB_.PCI0.RP05.R419 */
                            D41A = R41A /* \_SB_.PCI0.RP05.R41A */
                            D41C = R41C /* \_SB_.PCI0.RP05.R41C */
                            D420 = R420 /* \_SB_.PCI0.RP05.R420 */
                            D424 = R424 /* \_SB_.PCI0.RP05.R424 */
                            DVES = RVES /* \_SB_.PCI0.RP05.RVES */
                            D404 = 0x07
                            D518 = R518 /* \_SB_.PCI0.RP05.R518 */
                            D519 = R519 /* \_SB_.PCI0.RP05.R519 */
                            D51A = R51A /* \_SB_.PCI0.RP05.R51A */
                            D51C = R51C /* \_SB_.PCI0.RP05.R51C */
                            D520 = R520 /* \_SB_.PCI0.RP05.R520 */
                            D524 = R524 /* \_SB_.PCI0.RP05.R524 */
                            D504 = 0x07
                            If ((R219 == DP19))
                            {
                                Break
                            }

                            Sleep (One)
                            Local0--
                        }

                        If ((R219 != DP19))
                        {
                            Return (Zero)
                        }

                        DBG1 ("Wait for down link")
                        If ((WTDL () != One))
                        {
                            Return (Zero)
                        }

                        DBG1 ("Configure NHI")
                        Local0 = 0x64
                        While (Local0)
                        {
                            NH10 = RH10 /* \_SB_.PCI0.RP05.RH10 */
                            NH14 = RH14 /* \_SB_.PCI0.RP05.RH14 */
                            NH04 = 0x07
                            If ((RH10 == NH10))
                            {
                                Break
                            }

                            Sleep (One)
                            Local0--
                        }

                        DBG2 ("NHI BAR", NH10)
                        If ((RH10 != NH10))
                        {
                            Return (Zero)
                        }

                        DBG1 ("CNHI done")
                        Return (One)
                    }

                    Method (UPCK, 0, Serialized)
                    {
                        If (((UPVD & 0xFFFF) == 0x8086))
                        {
                            Return (One)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }

                    Method (ULTC, 0, Serialized)
                    {
                        If ((RPLT == Zero))
                        {
                            If ((UPLT == Zero))
                            {
                                Return (One)
                            }
                        }

                        Return (Zero)
                    }

                    Method (WTLT, 0, Serialized)
                    {
                        Local0 = 0x07D0
                        Local1 = Zero
                        While (Local0)
                        {
                            If ((RPR4 == 0x07))
                            {
                                If (ULTC ())
                                {
                                    If (UPCK ())
                                    {
                                        Local1 = One
                                        Break
                                    }
                                }
                            }

                            Sleep (One)
                            Local0--
                        }

                        Return (Local1)
                    }

                    Method (DLTC, 0, Serialized)
                    {
                        If ((RPLT == Zero))
                        {
                            If ((UPLT == Zero))
                            {
                                If ((DPLT == Zero))
                                {
                                    Return (One)
                                }
                            }
                        }

                        Return (Zero)
                    }

                    Method (WTDL, 0, Serialized)
                    {
                        Local0 = 0x07D0
                        Local1 = Zero
                        While (Local0)
                        {
                            If ((RPR4 == 0x07))
                            {
                                If (DLTC ())
                                {
                                    If (UPCK ())
                                    {
                                        Local1 = One
                                        Break
                                    }
                                }
                            }

                            Sleep (One)
                            Local0--
                        }

                        Return (Local1)
                    }

                    Scope (PXSX)
                    {
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
                            Return (SECB) /* \_SB_.PCI0.RP05.PXSX.SECB */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
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
                                Return (SECB) /* \_SB_.PCI0.RP05.PXSX.DSB0.SECB */
                            }

                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                Return (Zero)
                            }

                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If (_OSI ("Darwin"))
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
                                        "PCIHotplugCapable", 
                                        Zero
                                    })
                                }

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

                                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                                {
                                    If (_OSI ("Darwin"))
                                    {
                                        If ((Arg2 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x03                                             // .
                                            })
                                        }

                                        Return (Package (0x03)
                                        {
                                            "power-save", 
                                            One, 
                                            Buffer (One)
                                            {
                                                 0x00                                             // .
                                            }
                                        })
                                    }

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

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                Return (Zero)
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

                            Device (DEV0)
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

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                Return (Zero)
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

                            Device (DEV0)
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

                                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                                {
                                    Return (One)
                                }
                            }
                        }

                        Scope (TBDU)
                        {
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
                                Return (SECB) /* \_SB_.PCI0.RP05.PXSX.TBDU.SECB */
                            }

                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }

                            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                            {
                                Return (Zero)
                            }
                        }
                    }
                }
            }
        }
    }
}

