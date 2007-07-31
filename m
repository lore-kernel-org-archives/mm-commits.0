From: akpm@linux-foundation.org
Subject: - doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:45 -0700
Message-ID: <200707312355.l6VNtjM0029271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764248AbXHAARb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc/kernel-parameters: use X86-32 tag instead of IA-32
has been removed from the -mm tree.  Its filename was
     doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc/kernel-parameters: use X86-32 tag instead of IA-32
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |  114 +++++++++++++-------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32
+++ a/Documentation/kernel-parameters.txt
@@ -41,7 +41,6 @@ parameter is applicable:
 	EIDE	EIDE/ATAPI support is enabled.
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
-	IA-32	IA-32 aka i386 architecture is enabled.
 	IA-64	IA-64 architecture is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
@@ -92,6 +91,7 @@ parameter is applicable:
 	VT	Virtual terminal support is enabled.
 	WDT	Watchdog support is enabled.
 	XT	IBM PC/XT MFM hard disk support is enabled.
+	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
 			Documentation/x86_64/boot-options.txt .
@@ -219,7 +219,7 @@ and is between 256 and 4096 characters. 
 
 	acpi_fake_ecdt	[HW,ACPI] Workaround failure due to BIOS lacking ECDT
 
-	acpi_pm_good	[IA-32,X86-64]
+	acpi_pm_good	[X86-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
@@ -357,7 +357,7 @@ and is between 256 and 4096 characters. 
 
 	c101=		[NET] Moxa C101 synchronous serial card
 
-	cachesize=	[BUGS=IA-32] Override level 2 CPU cache size detection.
+	cachesize=	[BUGS=X86-32] Override level 2 CPU cache size detection.
 			Sometimes CPU hardware bugs make them report the cache
 			size incorrectly. The kernel will attempt work arounds
 			to fix known problems, but for some CPUs it is not
@@ -376,7 +376,7 @@ and is between 256 and 4096 characters. 
 			Value can be changed at runtime via
 				/selinux/checkreqprot.
 
-	clock=		[BUGS=IA-32, HW] gettimeofday clocksource override.
+	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used
 			when calculating gettimeofday(). If specified
@@ -394,7 +394,7 @@ and is between 256 and 4096 characters. 
 			[ARM] imx_timer1,OSTS,netx_timer,mpu_timer2,
 				pxa_timer,timer3,32k_counter,timer0_1
 			[AVR32] avr32
-			[IA-32] pit,hpet,tsc,vmi-timer;
+			[X86-32] pit,hpet,tsc,vmi-timer;
 				scx200_hrt on Geode; cyclone on IBM x440
 			[MIPS] MIPS
 			[PARISC] cr16
@@ -414,7 +414,7 @@ and is between 256 and 4096 characters. 
 			over the 8254 in addition to over the IO-APIC. The
 			kernel tries to set a sensible default.
 
-	hpet=		[IA-32,HPET] option to disable HPET and use PIT.
+	hpet=		[X86-32,HPET] option to disable HPET and use PIT.
 			Format: disable
 
 	com20020=	[HW,NET] ARCnet - COM20020 chipset
@@ -551,7 +551,7 @@ and is between 256 and 4096 characters. 
 
 	dtc3181e=	[HW,SCSI]
 
-	earlyprintk=	[IA-32,X86-64,SH]
+	earlyprintk=	[X86-32,X86-64,SH]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
 
@@ -589,7 +589,7 @@ and is between 256 and 4096 characters. 
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
-	elanfreq=	[IA-32]
+	elanfreq=	[X86-32]
 			See comment before function elanfreq_setup() in
 			arch/i386/kernel/cpu/cpufreq/elanfreq.c.
 
@@ -598,7 +598,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[IA-32, X86_64]
+	elfcorehdr=	[X86-32, X86_64]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.
@@ -680,7 +680,7 @@ and is between 256 and 4096 characters. 
 	hisax=		[HW,ISDN]
 			See Documentation/isdn/README.HiSax.
 
-	hugepages=	[HW,IA-32,IA-64] Maximal number of HugeTLB pages.
+	hugepages=	[HW,X86-32,IA-64] Maximal number of HugeTLB pages.
 
 	i8042.direct	[HW] Put keyboard port into non-translated mode
 	i8042.dumbkbd	[HW] Pretend that controller can only read data from
@@ -822,7 +822,7 @@ and is between 256 and 4096 characters. 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
-	kernelcore=nn[KMG]	[KNL,IA-32,IA-64,PPC,X86-64] This parameter
+	kernelcore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			specifies the amount of memory usable by the kernel
 			for non-movable allocations.  The requested amount is
 			spread evenly throughout all nodes in the system. The
@@ -838,7 +838,7 @@ and is between 256 and 4096 characters. 
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
-	movablecore=nn[KMG]	[KNL,IA-32,IA-64,PPC,X86-64] This parameter
+	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			is similar to kernelcore except it specifies the
 			amount of memory used for migratable allocations.
 			If both kernelcore and movablecore is specified,
@@ -850,21 +850,21 @@ and is between 256 and 4096 characters. 
 
 	keepinitrd	[HW,ARM]
 
-	kstack=N	[IA-32,X86-64] Print N words from the kernel stack
+	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.
 
 	l2cr=		[PPC]
 
-	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
+	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
-	lapic_timer_c2_ok	[IA-32,x86-64,APIC] trust the local apic timer in
+	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer in
 			C2 power state.
 
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
-	legacy_serial.force [HW,IA-32,X86-64]
+	legacy_serial.force [HW,X86-32,X86-64]
 			Probe for COM ports at legacy addresses even
 			if PNPBIOS or ACPI should describe them.  This
 			is for working around firmware defects.
@@ -974,11 +974,11 @@ and is between 256 and 4096 characters. 
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
 
-	mca-pentium	[BUGS=IA-32]
+	mca-pentium	[BUGS=X86-32]
 
 	mcatest=	[IA-64]
 
-	mce		[IA-32] Machine Check Exception
+	mce		[X86-32] Machine Check Exception
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
@@ -990,14 +990,14 @@ and is between 256 and 4096 characters. 
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[IA-32] Use together with memmap= to avoid physical
+			[X86-32] Use together with memmap= to avoid physical
 			address space collisions. Without memmap= PCI devices
 			could be placed at addresses belonging to unused RAM.
 
-	mem=nopentium	[BUGS=IA-32] Disable usage of 4MB pages for kernel
+	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
 
-	memmap=exactmap	[KNL,IA-32,X86_64] Enable setting of an exact
+	memmap=exactmap	[KNL,X86-32,X86_64] Enable setting of an exact
 			E820 memory map, as specified by the user.
 			Such memmap=exactmap lines can be constructed based on
 			BIOS output or other requirements. See the memmap=nn@ss
@@ -1083,9 +1083,9 @@ and is between 256 and 4096 characters. 
 			[NFS] set the maximum lifetime for idmapper cache
 			entries.
 
-	nmi_watchdog=	[KNL,BUGS=IA-32] Debugging features for SMP kernels
+	nmi_watchdog=	[KNL,BUGS=X86-32] Debugging features for SMP kernels
 
-	no387		[BUGS=IA-32] Tells the kernel to use the 387 maths
+	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
 			emulation library even if a 387 maths coprocessor
 			is present.
 
@@ -1116,17 +1116,17 @@ and is between 256 and 4096 characters. 
 
 	noexec		[IA-64]
 
-	noexec		[IA-32,X86-64]
+	noexec		[X86-32,X86-64]
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable nn-executable mappings
 
-	nofxsr		[BUGS=IA-32] Disables x86 floating point extended
+	nofxsr		[BUGS=X86-32] Disables x86 floating point extended
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
 	nohlt		[BUGS=ARM]
 
-	no-hlt		[BUGS=IA-32] Tells the kernel that the hlt
+	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
 			instruction doesn't work correctly and not to
 			use it.
 
@@ -1141,12 +1141,12 @@ and is between 256 and 4096 characters. 
 			Valid arguments: on, off
 			Default: on
 
-	noirqbalance	[IA-32,SMP,KNL] Disable kernel irq balancing
+	noirqbalance	[X86-32,SMP,KNL] Disable kernel irq balancing
 
-	noirqdebug	[IA-32] Disables the code which attempts to detect and
+	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
-	no_timer_check	[IA-32,X86_64,APIC] Disables the code which tests for
+	no_timer_check	[X86-32,X86_64,APIC] Disables the code which tests for
 			broken timer IRQ sources.
 
 	noisapnp	[ISAPNP] Disables ISA PnP code.
@@ -1158,20 +1158,20 @@ and is between 256 and 4096 characters. 
 
 	nojitter	[IA64] Disables jitter checking for ITC timers.
 
-	nolapic		[IA-32,APIC] Do not enable or use the local APIC.
+	nolapic		[X86-32,APIC] Do not enable or use the local APIC.
 
-	nolapic_timer	[IA-32,APIC] Do not use the local APIC timer.
+	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
 	nomca		[IA-64] Disable machine check abort handling
 
-	nomce		[IA-32] Machine Check Exception
+	nomce		[X86-32] Machine Check Exception
 
-	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
+	noreplace-paravirt	[X86-32,PV_OPS] Don't patch paravirt_ops
 
-	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
+	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
 	noresidual	[PPC] Don't use residual data on PReP machines.
@@ -1185,7 +1185,7 @@ and is between 256 and 4096 characters. 
 
 	nosbagart	[IA-64]
 
-	nosep		[BUGS=IA-32] Disables x86 SYSENTER/SYSEXIT support.
+	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
 
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel.
 
@@ -1193,7 +1193,7 @@ and is between 256 and 4096 characters. 
 
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
-	notsc		[BUGS=IA-32] Disable Time Stamp Counter
+	notsc		[BUGS=X86-32] Disable Time Stamp Counter
 
 	nousb		[USB] Disable the USB subsystem
 
@@ -1266,28 +1266,28 @@ and is between 256 and 4096 characters. 
 			See also Documentation/paride.txt.
 
 	pci=option[,option...]	[PCI] various PCI subsystem options:
-		off		[IA-32] don't probe for the PCI bus
-		bios		[IA-32] force use of PCI BIOS, don't access
+		off		[X86-32] don't probe for the PCI bus
+		bios		[X86-32] force use of PCI BIOS, don't access
 				the hardware directly. Use this if your machine
 				has a non-standard PCI host bridge.
-		nobios		[IA-32] disallow use of PCI BIOS, only direct
+		nobios		[X86-32] disallow use of PCI BIOS, only direct
 				hardware access methods are allowed. Use this
 				if you experience crashes upon bootup and you
 				suspect they are caused by the BIOS.
-		conf1		[IA-32] Force use of PCI Configuration
+		conf1		[X86-32] Force use of PCI Configuration
 				Mechanism 1.
-		conf2		[IA-32] Force use of PCI Configuration
+		conf2		[X86-32] Force use of PCI Configuration
 				Mechanism 2.
-		nommconf	[IA-32,X86_64] Disable use of MMCONFIG for PCI
+		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
 				enabled, this kernel boot option can be used to
 				disable the use of MSI interrupts system-wide.
-		nosort		[IA-32] Don't sort PCI devices according to
+		nosort		[X86-32] Don't sort PCI devices according to
 				order given by the PCI BIOS. This sorting is
 				done to get a device order compatible with
 				older kernels.
-		biosirq		[IA-32] Use PCI BIOS calls to get the interrupt
+		biosirq		[X86-32] Use PCI BIOS calls to get the interrupt
 				routing table. These calls are known to be buggy
 				on several machines and they hang the machine
 				when used, but on other computers it's the only
@@ -1295,32 +1295,32 @@ and is between 256 and 4096 characters. 
 				this option if the kernel is unable to allocate
 				IRQs or discover secondary PCI buses on your
 				motherboard.
-		rom		[IA-32] Assign address space to expansion ROMs.
+		rom		[X86-32] Assign address space to expansion ROMs.
 				Use with caution as certain devices share
 				address decoders between ROMs and other
 				resources.
-		irqmask=0xMMMM	[IA-32] Set a bit mask of IRQs allowed to be
+		irqmask=0xMMMM	[X86-32] Set a bit mask of IRQs allowed to be
 				assigned automatically to PCI devices. You can
 				make the kernel exclude IRQs of your ISA cards
 				this way.
-		pirqaddr=0xAAAAA	[IA-32] Specify the physical address
+		pirqaddr=0xAAAAA	[X86-32] Specify the physical address
 				of the PIRQ table (normally generated
 				by the BIOS) if it is outside the
 				F0000h-100000h range.
-		lastbus=N	[IA-32] Scan all buses thru bus #N. Can be
+		lastbus=N	[X86-32] Scan all buses thru bus #N. Can be
 				useful if the kernel is unable to find your
 				secondary buses and you want to tell it
 				explicitly which ones they are.
-		assign-busses	[IA-32] Always assign all PCI bus
+		assign-busses	[X86-32] Always assign all PCI bus
 				numbers ourselves, overriding
 				whatever the firmware may have done.
-		usepirqmask	[IA-32] Honor the possible IRQ mask stored
+		usepirqmask	[X86-32] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
 				some HP Pavilion N5400 and Omnibook XE3
 				notebooks. This will have no effect if ACPI
 				IRQ routing is enabled.
-		noacpi		[IA-32] Do not use ACPI for IRQ routing
+		noacpi		[X86-32] Do not use ACPI for IRQ routing
 				or for PCI scanning.
 		routeirq	Do IRQ routing for all PCI devices.
 				This is normally done in pci_enable_device(),
@@ -1469,13 +1469,13 @@ and is between 256 and 4096 characters. 
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	reboot=		[BUGS=IA-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
+	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
 
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
-	reservetop=	[IA-32]
+	reservetop=	[X86-32]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
 			address space.
@@ -1566,7 +1566,7 @@ and is between 256 and 4096 characters. 
                         Value can be changed at runtime via
                         /selinux/compat_net.
 
-	serialnumber	[BUGS=IA-32]
+	serialnumber	[BUGS=X86-32]
 
 	sg_def_reserved_size=	[SCSI]
 
@@ -1619,7 +1619,7 @@ and is between 256 and 4096 characters. 
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
-	smp-alt-once	[IA-32,SMP] On a hotplug CPU system, only
+	smp-alt-once	[X86-32,SMP] On a hotplug CPU system, only
 			attempt to substitute SMP alternatives once at boot.
 
 	smsc-ircc2.nopnp	[HW] Don't use PNP to discover SMC devices
@@ -1884,7 +1884,7 @@ and is between 256 and 4096 characters. 
 	usbhid.mousepoll=
 			[USBHID] The interval which mice are to be polled at.
 
-	vdso=		[IA-32,SH,x86-64]
+	vdso=		[X86-32,SH,x86-64]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
@@ -1895,7 +1895,7 @@ and is between 256 and 4096 characters. 
 	video=		[FB] Frame buffer configuration
 			See Documentation/fb/modedb.txt.
 
-	vga=		[BOOT,IA-32] Select a particular video mode
+	vga=		[BOOT,X86-32] Select a particular video mode
 			See Documentation/i386/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
nozomi-shoot-defunct-label.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
pata_cmd64x-correct-the-speed-ranges.patch
libata-correct-iordy-handling.patch
pata_sis-fix-mwdma-for-=-udma66-chipsets-and-udma-for-udma33-chipsets.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
