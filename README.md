[![](https://img.shields.io/badge/Gitter%20Ice%20Lake-Chat-informational?style=flat&logo=gitter&logoColor=white&color=ed1965)](https://gitter.im/ICE-LAKE-HACKINTOSH-DEVELOPMENT/community)
[![](https://img.shields.io/badge/EFI-Release-informational?style=flat&logo=apple&logoColor=white&color=9debeb)](https://github.com/Baio1977/EFI-Varie-Hackintosh)
[![](https://img.shields.io/badge/Telegram-HackintoshLifeIT-informational?style=flat&logo=telegram&logoColor=white&color=5fb659)](https://t.me/HackintoshLife_it)
[![](https://img.shields.io/badge/Facebook-HackintoshLifeIT-informational?style=flat&logo=facebook&logoColor=white&color=3a4dc9)](https://www.facebook.com/hackintoshlife/)
[![](https://img.shields.io/badge/Instagram-HackintoshLifeIT-informational?style=flat&logo=instagram&logoColor=white&color=8a178a)](https://www.instagram.com/hackintoshlife.it_official/)

# NUC8i7HVK-Hackintosh

![Lenovo](./Screenshot/1.jpg)

![Lenovo](./Screenshot/2.jpg)
 
## Specification:

- CPU: 1.6GHz Intel Core i5-8250U (Kaby Lake-R)
- Memory: 2x4GB 1,867MHz LPDDR3
- Harddrive: 256GB PCIe-NVMe M.2 SSD
- Display: 13-inch IPS-Touch Screen (3000×2000) 
- GPU: Intel UHD 620
- Camera: Front: 2MP, rear: 8MP
- WLAN: Intel dual-band 8265 Wireless 802.11ac (2 x 2) & Bluetooth 4.1
- Battery: Integrate Li-Polymer 42Wh internal battery
- Audio: Realtek HDA ALC295
- 2 x USB-C/Thunderbolt 3 Alpine Ridge (power delivery, DisplayPort, data transfer)
- NanoSIM card/microSD combo slot
- Headphone / mic combo 

## BIOS Settings:V 1.48

The bios must be properly configured prior to installing macOS.
In Security menu, set the following settings:

-  `Security > Security Chip`: must be **Disabled**
-  `Memory Protection > Execution Prevention`: must be **Enabled**
-  `Virtualization > Intel Virtualization Technology`: must be **Enabled**
-  `Virtualization > Intel VT-d Feature`: must be **Enabled**
-  `Anti-Theft > Computrace -> Current Setting`: must be **Disabled**
-  `Secure Boot > Secure Boot`: must be **Disabled**
-  `Intel SGX -> Intel SGX Control`: must be **Disabled**
-  `Device Guard`: must be **Disabled**

In Startup menu, set the following options:

-  `UEFI/Legacy Boot`: **UEFI Only**
-  `CSM Support`: **No**

In Thunderbolt menu, set the following options:

-  `Thunderbolt BIOS Assist Mode`: **UEFI Only**
-  `Wake by Thunderbolt(TM) 3`: **No**
-  `Security Level`: **No**
-  `Support in Pre Boot Environment > Thunderbolt(TM) device`: **No**

In Display menu, set the following options:
         
-  `Boot Display Device` : **LCD**
-  `Shared Display Priority` **HDMI**
-  `Total Garphics Memory` : **512MB** If you set it like this in Bios you can delete "framebuffer-fbmem | Data | 00009000" in patch IGPU.
-  `Boot Time Extension` : **Disabled**	   
   
## Working:

 - Keyboard (USB)
 - Touchscreen with gestures and Pen (Fix 10\9\2023)
 - Battery indicator
 - Audio (Internal)
 - GPU acceleration
 - Camera
 - Intel Wireless / Bluetooth
 - Native CPU power management
 - MicroSD card reader
 - HDMI video and audio 
 - Thunderbolt JHL6540 Alpine Ridge Work whit HotPlug 
 - Sleep\Wake Fix 30\8\2023 Thank [Vorshim92](https://github.com/Vorshim92)
 - Trackpad (USB) 9\9\2023 Thank [Lorys89](https://github.com/Lorys89)
   
 - ## Not Work:

 - Microphone 
 
## USB Map:

![Lenovo](./Screenshot/3.png)
