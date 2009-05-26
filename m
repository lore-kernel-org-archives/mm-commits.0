From: akpm@linux-foundation.org
Subject: + maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch added to -mm tree
Date: Tue, 26 May 2009 14:42:13 -0700
Message-ID: <200905262142.n4QLgDX2030002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbZEZVnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: remove L:	linux-kernel@vger.kernel.org from all but "THE REST"
has been added to the -mm tree.  Its filename is
     maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove L:	linux-kernel@vger.kernel.org from all but "THE REST"
From: Joe Perches <joe@perches.com>

lkml is added to all CC lists via pattern matching on "THE REST"

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   81 --------------------------------------------------
 1 file changed, 81 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest
+++ a/MAINTAINERS
@@ -907,7 +907,6 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
-L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 F:	Documentation/crypto/async-tx-api.txt
@@ -1003,7 +1002,6 @@ F:	drivers/mmc/host/at91_mci.c
 ATMEL AT91 / AT32 SERIAL DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/serial/atmel_serial.c
 
@@ -1059,7 +1057,6 @@ F:	kernel/audit*
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1129,7 +1126,6 @@ F:	drivers/net/hamradio/baycom*
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
@@ -1137,7 +1133,6 @@ F:	fs/befs/
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
@@ -1194,7 +1189,6 @@ F:	drivers/i2c/busses/i2c-bfin-twi.c
 BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
@@ -1321,7 +1315,6 @@ P:	Muli Ben-Yehuda
 M:	muli@il.ibm.com
 P:	Jon D. Mason
 M:	jdmason@kudzu.us
-L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
 F:	arch/x86/kernel/pci-calgary_64.c
@@ -1373,7 +1366,6 @@ F:	include/linux/usb/wusb*
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1383,7 +1375,6 @@ F:	include/linux/cfag12864b.h
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1403,7 +1394,6 @@ X:	net/wireless/wext*
 CHECKPATCH
 P:	Andy Whitcroft
 M:	apw@canonical.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	scripts/checkpatch.pl
 
@@ -1529,7 +1519,6 @@ F:	drivers/usb/atm/cxacru.c
 CONFIGFS
 P:	Joel Becker
 M:	joel.becker@oracle.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	fs/configfs/
 F:	include/linux/configfs.h
@@ -1580,7 +1569,6 @@ F:	arch/x86/kernel/msr.c
 CPUSETS
 P:	Paul Menage
 M:	menage@google.com
-L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
@@ -1787,7 +1775,6 @@ DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
 M:	device@lanana.org
 W:	http://lanana.org/docs/device-list/index.html
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 DEVICE-MAPPER  (LVM)
@@ -1813,7 +1800,6 @@ F:	drivers/char/digi*
 DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/dnotify.txt
 F:	fs/notify/dnotify/
@@ -1830,7 +1816,6 @@ S:	Maintained
 DISKQUOTA
 P:	Jan Kara
 M:	jack@suse.cz
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
@@ -1852,7 +1837,6 @@ P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
 P:	Dan Williams
 M:	dan.j.williams@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
@@ -1904,7 +1888,6 @@ F:	drivers/scsi/dpt/
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
@@ -2242,7 +2225,6 @@ F:	drivers/firewire/
 F:	include/linux/firewire*.h
 
 FIRMWARE LOADER (request_firmware)
-L:	linux-kernel@vger.kernel.org
 S:	Orphan
 F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
@@ -2279,7 +2261,6 @@ M:	leoli@freescale.com
 P:	Zhang Wei
 M:	zw@zh-kernel.org
 L:	linuxppc-embedded@ozlabs.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/dma/fsldma.*
 
@@ -2479,7 +2460,6 @@ F:	drivers/hwmon/hdaps.c
 
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@ozlabs.org
-L:	linux-kernel@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/char/hvc_*
 
@@ -2546,7 +2526,6 @@ F:	sound/parisc/harmony.*
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
 M:	arobinso@nyx.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
 F:	Documentation/serial/hayes-esp.txt
@@ -2572,7 +2551,6 @@ F:	include/linux/cciss_ioctl.h
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
@@ -2612,7 +2590,6 @@ F:	include/linux/hid*
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
@@ -2751,7 +2728,6 @@ F:	drivers/i2c/busses/i2c-tiny-usb.c
 i386 BOOT CODE
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-L:	Linux-Kernel@vger.kernel.org
 S:	Maintained
 F:	arch/x86/boot/
 
@@ -2869,7 +2845,6 @@ P:	Robert Love
 M:	rlove@rlove.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/notify/inotify/
@@ -2917,7 +2892,6 @@ F:	arch/x86/kernel/microcode_intel.c
 INTEL I/OAT DMA DRIVER
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/ioat*
 
@@ -2933,7 +2907,6 @@ F:	include/linux/intel-iommu.h
 INTEL IOP-ADMA DMA DRIVER
 P:	Dan Williams
 M:	dan.j.williams@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/iop-adma.c
 
@@ -3245,7 +3218,6 @@ M:	vgoyal@redhat.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
 L:	kexec@lists.infradead.org
-L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
 F:	Documentation/kdump/
@@ -3355,7 +3327,6 @@ KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
-L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
@@ -3375,7 +3346,6 @@ F:	kernel/kgdb.c
 KMEMTRACE
 P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
@@ -3396,7 +3366,6 @@ P:	David S. Miller
 M:	davem@davemloft.net
 P:	Masami Hiramatsu
 M:	mhiramat@redhat.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/kprobes.txt
 F:	include/linux/kprobes.h
@@ -3405,7 +3374,6 @@ F:	kernel/kprobes.c
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -3569,7 +3537,6 @@ P:	Peter Zijlstra
 M:	peterz@infradead.org
 P:	Ingo Molnar
 M:	mingo@redhat.com
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep*.txt
@@ -3704,7 +3671,6 @@ F:	include/linux/mv643xx.h
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 MARVELL YUKON / SYSKONNECT DRIVER
@@ -3758,7 +3724,6 @@ F:	drivers/scsi/megaraid/
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
 F:	include/linux/mm.h
@@ -3772,7 +3737,6 @@ M:	xemul@openvz.org
 P:	KAMEZAWA Hiroyuki
 M:	kamezawa.hiroyu@jp.fujitsu.com
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	mm/memcontrol.c
 
@@ -3815,7 +3779,6 @@ F:	arch/mips/
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ia64/mca.txt
 F:	Documentation/mca.txt
@@ -3825,7 +3788,6 @@ F:	include/linux/mca*
 MODULE SUPPORT
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/module.h
 F:	kernel/module.c
@@ -3849,7 +3811,6 @@ F:	drivers/mmc/host/imxmmc.*
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini
 M:	rubini@ipvvis.unipv.it
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/input/mouse/
 F:	include/linux/gpio_mouse.h
@@ -3857,7 +3818,6 @@ F:	include/linux/gpio_mouse.h
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
@@ -3873,7 +3833,6 @@ F:	drivers/platform/x86/msi-laptop.c
 MULTIFUNCTION DEVICES (MFD)
 P:	Samuel Ortiz
 M:	sameo@linux.intel.com
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
 S:	Supported
 F:	drivers/mfd/
@@ -3881,7 +3840,6 @@ F:	drivers/mfd/
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	pierre@ossman.eu
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
@@ -3889,7 +3847,6 @@ F:	include/linux/mmc/
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
-L:	linux-kernel@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/mmc/host/mmc_spi.c
 F:	include/linux/spi/mmc_spi.h
@@ -3904,7 +3861,6 @@ F:	sound/oss/msnd*
 MULTITECH MULTIPORT CARD (ISICOM)
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
@@ -4148,7 +4104,6 @@ NTFS FILESYSTEM
 P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
@@ -4324,7 +4279,6 @@ M:	akataria@vmware.com
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/ia64/paravirt_ops.txt
 F:	arch/*/kernel/paravirt*
@@ -4375,7 +4329,6 @@ F:	include/linux/leds-pca9532.h
 PCI ERROR RECOVERY
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
@@ -4384,7 +4337,6 @@ F:	Documentation/powerpc/eeh-pci-error-r
 PCI SUBSYSTEM
 P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
-L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
@@ -4419,7 +4371,6 @@ F:	drivers/net/pcnet32.c
 PER-TASK DELAY ACCOUNTING
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
@@ -4441,7 +4392,6 @@ F:	drivers/mtd/devices/phram.c
 PKTCDVD DRIVER
 P:	Peter Osterlund
 M:	petero2@telia.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
@@ -4449,7 +4399,6 @@ F:	include/linux/pktcdvd.h
 POSIX CLOCKS and TIMERS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	fs/timerfd.c
 F:	include/linux/timer*
@@ -4460,7 +4409,6 @@ P:	Anton Vorontsov
 M:	cbou@mail.ru
 P:	David Woodhouse
 M:	dwmw2@infradead.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
 F:	include/linux/power_supply.h
@@ -4512,7 +4460,6 @@ F:	include/linux/if_pppol2tp.h
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
-L:	linux-kernel@vger.kernel.org
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
@@ -4575,7 +4522,6 @@ P:	Roland McGrath
 M:	roland@redhat.com
 P:	Oleg Nesterov
 M:	oleg@redhat.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
@@ -4661,7 +4607,6 @@ F:	drivers/net/qlge/
 QNX4 FILESYSTEM
 P:	Anders Larsen
 M:	al@alarsen.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
 F:	fs/qnx4/
@@ -4708,7 +4653,6 @@ F:	drivers/char/random.c
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/rapidio/
 
@@ -4722,7 +4666,6 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
@@ -4730,7 +4673,6 @@ F:	kernel/rcutorture.c
 RDC R-321X SoC
 P:	Florian Fainelli
 M:	florian@openwrt.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 RDC R6040 FAST ETHERNET DRIVER
@@ -4751,7 +4693,6 @@ READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/RCU/rcu.txt
 F:	Documentation/RCU/rcuref.txt
@@ -4762,7 +4703,6 @@ F:	kernel/rcupdate.c
 REAL TIME CLOCK DRIVER
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
@@ -4900,7 +4840,6 @@ S3C24XX SD/MMC Driver
 P:	Ben Dooks
 M:	ben-linux@fluff.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -4926,7 +4865,6 @@ P:	Ingo Molnar
 M:	mingo@elte.hu
 P:	Peter Zijlstra
 M:	peterz@infradead.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
@@ -5028,7 +4966,6 @@ F:	drivers/mmc/host/sdhci.*
 SECURITY SUBSYSTEM
 P:	James Morris
 M:	jmorris@namei.org
-L:	linux-kernel@vger.kernel.org
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
@@ -5047,7 +4984,6 @@ P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
@@ -5311,7 +5247,6 @@ F:	include/linux/sony-laptop.h
 SONY MEMORYSTICK CARD SUPPORT
 P:	Alex Dubov
 M:	oakad@yahoo.com
-L:	linux-kernel@vger.kernel.org
 W:	http://tifmxx.berlios.de/
 S:	Maintained
 F:	drivers/memstick/host/tifm_ms.c
@@ -5354,7 +5289,6 @@ F:	arch/sparc/
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/serial/specialix.txt
 F:	drivers/char/specialix*
@@ -5400,7 +5334,6 @@ F:	fs/squashfs/
 SRM (Alpha) environment access
 P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	arch/alpha/kernel/srm_env.c
 
@@ -5415,7 +5348,6 @@ S:	Maintained
 STAGING SUBSYSTEM
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Maintained
 F:	drivers/staging/
@@ -5495,7 +5427,6 @@ F:	include/linux/sysv_fs.h
 TASKSTATS STATISTICS INTERFACE
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
@@ -5602,7 +5533,6 @@ P:	Kentaro Takeda
 M:	takedakn@nttdata.co.jp
 P:	Tetsuo Handa
 M:	penguin-kernel@I-love.SAKURA.ne.jp
-L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	tomoyo-users-en@lists.sourceforge.jp (subscribers-only, for developers and users in English)
 L:	tomoyo-dev@lists.sourceforge.jp (subscribers-only, for developers in Japanese)
 L:	tomoyo-users@lists.sourceforge.jp (subscribers-only, for users in Japanese)
@@ -5654,14 +5584,12 @@ F:	drivers/char/tpm/
 TRIVIAL PATCHES
 P:	Jiri Kosina
 M:	trivial@kernel.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
 
 TTY LAYER
 P:	Alan Cox
 M:	alan@lxorguk.ukuu.org.uk
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 TULIP NETWORK DRIVERS
@@ -5733,7 +5661,6 @@ F:	fs/udf/
 UFS FILESYSTEM
 P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ufs.txt
 F:	fs/ufs/
@@ -5750,7 +5677,6 @@ F:	include/linux/uwb/
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
-L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 F:	Documentation/cdrom/
@@ -5779,7 +5705,6 @@ F:	drivers/usb/class/cdc-acm.*
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/block/ub.c
@@ -6125,7 +6050,6 @@ P:	Hans J. Koch
 M:	hjk@linutronix.de
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
@@ -6151,7 +6075,6 @@ F:	drivers/video/uvesafb.*
 VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
@@ -6248,7 +6171,6 @@ F:	drivers/hwmon/w83793.c
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
 M:	pierre@ossman.eu
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/wbsd.*
 
@@ -6335,7 +6257,6 @@ M:	mingo@redhat.com
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 M:	x86@kernel.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
 F:	Documentation/x86/
@@ -6371,7 +6292,6 @@ XILINX SYSTEMACE DRIVER
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 W:	http://www.secretlab.ca/
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/xsysace.c
 
@@ -6442,4 +6362,3 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Buried alive in reporters
 F:	*
 F:	*/
