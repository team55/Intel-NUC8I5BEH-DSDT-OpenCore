// STICK6 model specific SSDT

DefinitionBlock("", "SSDT", 2, "hack", "_STCK6", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove

        // AUDL: Audio Layout
        //
        // The value here will be used to inject layout-id for HDEF and HDAU
        // If set to Ones, no audio injection will be done.
        Name(AUDL, 2)

        // FAKH: Fake HDMI Aduio
        //
        // 0: Disable spoofing of HDEF for FakePCIID_Intel_HDMI_Audio.kext
        // 1: Allow spoofing of HDEF for FakePCIID_Intel_HDMI_Audio.kext
        Name(FAKH, 0)
    }

    // The Stick has no GLAN nor XDCI, yet these objects return "present" for _STA
    // Each also has a _PRW. This causes "instant wake"
    // To avoid it, _PRW could be patched, but that is difficult with hotpatch because
    // of other _PRW methods that are not affected.
    // So, instead patch/replace _STA, which is probably a better fix anyway
    // GLAN is easy as DSDT does not define GLAN._STA
    Name(_SB.PCI0.GLAN._STA, 0)
    #include "SSDT-XDCI.dsl"

    #include "SSDT-XOSI.dsl"
    #include "SSDT-IGPU.dsl"
    #include "SSDT-USBX.dsl"
    #include "SSDT-USB-STCK.dsl"
    #include "SSDT-XHC.dsl"
    #include "SSDT-HDEF.dsl"
    #include "SSDT-EC.dsl"
    #include "SSDT-PTS.dsl"
    #include "SSDT-RMNE.dsl"
}
//EOF
