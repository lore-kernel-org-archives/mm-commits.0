From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:33 -0700
Message-ID: <200906171838.n5HIcXNt004626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbZFQSqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove L:	linux-kernel@vger.kernel.org from all but "THE REST"
has been removed from the -mm tree.  Its filename was
     maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -912,7 +912,6 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
-L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 F:	Documentation/crypto/async-tx-api.txt
@@ -1008,7 +1007,6 @@ F:	drivers/mmc/host/at91_mci.c
 ATMEL AT91 / AT32 SERIAL DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/serial/atmel_serial.c
 
@@ -1064,7 +1062,6 @@ F:	kernel/audit*
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1134,7 +1131,6 @@ F:	drivers/net/hamradio/baycom*
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
@@ -1142,7 +1138,6 @@ F:	fs/befs/
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
@@ -1199,7 +1194,6 @@ F:	drivers/i2c/busses/i2c-bfin-twi.c
 BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
@@ -1326,7 +1320,6 @@ P:	Muli Ben-Yehuda
 M:	muli@il.ibm.com
 P:	Jon D. Mason
 M:	jdmason@kudzu.us
-L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
 F:	arch/x86/kernel/pci-calgary_64.c
@@ -1378,7 +1371,6 @@ F:	include/linux/usb/wusb*
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1388,7 +1380,6 @@ F:	include/linux/cfag12864b.h
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1408,7 +1399,6 @@ X:	net/wireless/wext*
 CHECKPATCH
 P:	Andy Whitcroft
 M:	apw@canonical.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	scripts/checkpatch.pl
 
@@ -1534,7 +1524,6 @@ F:	drivers/usb/atm/cxacru.c
 CONFIGFS
 P:	Joel Becker
 M:	joel.becker@oracle.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	fs/configfs/
 F:	include/linux/configfs.h
@@ -1592,7 +1581,6 @@ F:	arch/x86/kernel/msr.c
 CPUSETS
 P:	Paul Menage
 M:	menage@google.com
-L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
@@ -1799,7 +1787,6 @@ DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
 M:	device@lanana.org
 W:	http://lanana.org/docs/device-list/index.html
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 DEVICE-MAPPER  (LVM)
@@ -1825,7 +1812,6 @@ F:	drivers/char/digi*
 DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/dnotify.txt
 F:	fs/notify/dnotify/
@@ -1842,7 +1828,6 @@ S:	Maintained
 DISKQUOTA
 P:	Jan Kara
 M:	jack@suse.cz
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
@@ -1864,7 +1849,6 @@ P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
 P:	Dan Williams
 M:	dan.j.williams@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
@@ -1916,7 +1900,6 @@ F:	drivers/scsi/dpt/
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
@@ -2263,7 +2246,6 @@ F:	drivers/firewire/
 F:	include/linux/firewire*.h
 
 FIRMWARE LOADER (request_firmware)
-L:	linux-kernel@vger.kernel.org
 S:	Orphan
 F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
@@ -2300,7 +2282,6 @@ M:	leoli@freescale.com
 P:	Zhang Wei
 M:	zw@zh-kernel.org
 L:	linuxppc-dev@ozlabs.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/dma/fsldma.*
 
@@ -2500,7 +2481,6 @@ F:	drivers/hwmon/hdaps.c
 
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@ozlabs.org
-L:	linux-kernel@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/char/hvc_*
 
@@ -2567,7 +2547,6 @@ F:	sound/parisc/harmony.*
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
 M:	arobinso@nyx.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
 F:	Documentation/serial/hayes-esp.txt
@@ -2593,7 +2572,6 @@ F:	include/linux/cciss_ioctl.h
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
@@ -2633,7 +2611,6 @@ F:	include/linux/hid*
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
@@ -2772,7 +2749,6 @@ F:	drivers/i2c/busses/i2c-tiny-usb.c
 i386 BOOT CODE
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-L:	Linux-Kernel@vger.kernel.org
 S:	Maintained
 F:	arch/x86/boot/
 
@@ -2902,7 +2878,6 @@ P:	Robert Love
 M:	rlove@rlove.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/notify/inotify/
@@ -2950,7 +2925,6 @@ F:	arch/x86/kernel/microcode_intel.c
 INTEL I/OAT DMA DRIVER
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/ioat*
 
@@ -2966,7 +2940,6 @@ F:	include/linux/intel-iommu.h
 INTEL IOP-ADMA DMA DRIVER
 P:	Dan Williams
 M:	dan.j.williams@intel.com
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/dma/iop-adma.c
 
@@ -3279,7 +3252,6 @@ M:	vgoyal@redhat.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
 L:	kexec@lists.infradead.org
-L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
 F:	Documentation/kdump/
@@ -3389,7 +3361,6 @@ KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
-L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
@@ -3419,7 +3390,6 @@ F:	mm/kmemleak-test.c
 KMEMTRACE
 P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/trace/kmemtrace.txt
 F:	include/trace/kmemtrace.h
@@ -3434,7 +3404,6 @@ P:	David S. Miller
 M:	davem@davemloft.net
 P:	Masami Hiramatsu
 M:	mhiramat@redhat.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/kprobes.txt
 F:	include/linux/kprobes.h
@@ -3443,7 +3412,6 @@ F:	kernel/kprobes.c
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
-L:	linux-kernel@vger.kernel.org
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -3607,7 +3575,6 @@ P:	Peter Zijlstra
 M:	peterz@infradead.org
 P:	Ingo Molnar
 M:	mingo@redhat.com
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep*.txt
@@ -3742,7 +3709,6 @@ F:	include/linux/mv643xx.h
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 MARVELL YUKON / SYSKONNECT DRIVER
@@ -3796,7 +3762,6 @@ F:	drivers/scsi/megaraid/
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
 F:	include/linux/mm.h
@@ -3810,7 +3775,6 @@ M:	xemul@openvz.org
 P:	KAMEZAWA Hiroyuki
 M:	kamezawa.hiroyu@jp.fujitsu.com
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	mm/memcontrol.c
 
@@ -3853,7 +3817,6 @@ F:	arch/mips/
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ia64/mca.txt
 F:	Documentation/mca.txt
@@ -3863,7 +3826,6 @@ F:	include/linux/mca*
 MODULE SUPPORT
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/module.h
 F:	kernel/module.c
@@ -3887,7 +3849,6 @@ F:	drivers/mmc/host/imxmmc.*
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini
 M:	rubini@ipvvis.unipv.it
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/input/mouse/
 F:	include/linux/gpio_mouse.h
@@ -3895,7 +3856,6 @@ F:	include/linux/gpio_mouse.h
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
@@ -3911,7 +3871,6 @@ F:	drivers/platform/x86/msi-laptop.c
 MULTIFUNCTION DEVICES (MFD)
 P:	Samuel Ortiz
 M:	sameo@linux.intel.com
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
 S:	Supported
 F:	drivers/mfd/
@@ -3919,7 +3878,6 @@ F:	drivers/mfd/
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	pierre@ossman.eu
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
@@ -3927,7 +3885,6 @@ F:	include/linux/mmc/
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
-L:	linux-kernel@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/mmc/host/mmc_spi.c
 F:	include/linux/spi/mmc_spi.h
@@ -3942,7 +3899,6 @@ F:	sound/oss/msnd*
 MULTITECH MULTIPORT CARD (ISICOM)
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
@@ -4186,7 +4142,6 @@ NTFS FILESYSTEM
 P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-ntfs.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
@@ -4420,7 +4375,6 @@ M:	akataria@vmware.com
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/ia64/paravirt_ops.txt
 F:	arch/*/kernel/paravirt*
@@ -4471,7 +4425,6 @@ F:	include/linux/leds-pca9532.h
 PCI ERROR RECOVERY
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
@@ -4480,7 +4433,6 @@ F:	Documentation/powerpc/eeh-pci-error-r
 PCI SUBSYSTEM
 P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
-L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
@@ -4515,7 +4467,6 @@ F:	drivers/net/pcnet32.c
 PER-TASK DELAY ACCOUNTING
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
@@ -4547,7 +4498,6 @@ F:	drivers/mtd/devices/phram.c
 PKTCDVD DRIVER
 P:	Peter Osterlund
 M:	petero2@telia.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
@@ -4555,7 +4505,6 @@ F:	include/linux/pktcdvd.h
 POSIX CLOCKS and TIMERS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	fs/timerfd.c
 F:	include/linux/timer*
@@ -4566,7 +4515,6 @@ P:	Anton Vorontsov
 M:	cbou@mail.ru
 P:	David Woodhouse
 M:	dwmw2@infradead.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
 F:	include/linux/power_supply.h
@@ -4618,7 +4566,6 @@ F:	include/linux/if_pppol2tp.h
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
-L:	linux-kernel@vger.kernel.org
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
@@ -4681,7 +4628,6 @@ P:	Roland McGrath
 M:	roland@redhat.com
 P:	Oleg Nesterov
 M:	oleg@redhat.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
@@ -4767,7 +4713,6 @@ F:	drivers/net/qlge/
 QNX4 FILESYSTEM
 P:	Anders Larsen
 M:	al@alarsen.net
-L:	linux-kernel@vger.kernel.org
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
 F:	fs/qnx4/
@@ -4814,7 +4759,6 @@ F:	drivers/char/random.c
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/rapidio/
 
@@ -4828,7 +4772,6 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
@@ -4836,7 +4779,6 @@ F:	kernel/rcutorture.c
 RDC R-321X SoC
 P:	Florian Fainelli
 M:	florian@openwrt.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 RDC R6040 FAST ETHERNET DRIVER
@@ -4857,7 +4799,6 @@ READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/RCU/rcu.txt
 F:	Documentation/RCU/rcuref.txt
@@ -4868,7 +4809,6 @@ F:	kernel/rcupdate.c
 REAL TIME CLOCK DRIVER
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
@@ -5006,7 +4946,6 @@ S3C24XX SD/MMC Driver
 P:	Ben Dooks
 M:	ben-linux@fluff.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -5032,7 +4971,6 @@ P:	Ingo Molnar
 M:	mingo@elte.hu
 P:	Peter Zijlstra
 M:	peterz@infradead.org
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
@@ -5134,7 +5072,6 @@ F:	drivers/mmc/host/sdhci.*
 SECURITY SUBSYSTEM
 P:	James Morris
 M:	jmorris@namei.org
-L:	linux-kernel@vger.kernel.org
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
@@ -5153,7 +5090,6 @@ P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
@@ -5416,7 +5352,6 @@ F:	include/linux/sony-laptop.h
 SONY MEMORYSTICK CARD SUPPORT
 P:	Alex Dubov
 M:	oakad@yahoo.com
-L:	linux-kernel@vger.kernel.org
 W:	http://tifmxx.berlios.de/
 S:	Maintained
 F:	drivers/memstick/host/tifm_ms.c
@@ -5459,7 +5394,6 @@ F:	arch/sparc/
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/serial/specialix.txt
 F:	drivers/char/specialix*
@@ -5505,7 +5439,6 @@ F:	fs/squashfs/
 SRM (Alpha) environment access
 P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	arch/alpha/kernel/srm_env.c
 
@@ -5520,7 +5453,6 @@ S:	Maintained
 STAGING SUBSYSTEM
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Maintained
 F:	drivers/staging/
@@ -5600,7 +5532,6 @@ F:	include/linux/sysv_fs.h
 TASKSTATS STATISTICS INTERFACE
 P:	Balbir Singh
 M:	balbir@linux.vnet.ibm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
@@ -5693,7 +5624,6 @@ P:	Kentaro Takeda
 M:	takedakn@nttdata.co.jp
 P:	Tetsuo Handa
 M:	penguin-kernel@I-love.SAKURA.ne.jp
-L:	linux-kernel@vger.kernel.org (kernel issues)
 L:	tomoyo-users-en@lists.sourceforge.jp (subscribers-only, for developers and users in English)
 L:	tomoyo-dev@lists.sourceforge.jp (subscribers-only, for developers in Japanese)
 L:	tomoyo-users@lists.sourceforge.jp (subscribers-only, for users in Japanese)
@@ -5745,14 +5675,12 @@ F:	drivers/char/tpm/
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
 T:	stgit http://zeniv.linux.org.uk/~alan/ttydev/
 
@@ -5825,7 +5753,6 @@ F:	fs/udf/
 UFS FILESYSTEM
 P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ufs.txt
 F:	fs/ufs/
@@ -5842,7 +5769,6 @@ F:	include/linux/uwb/
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
-L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 F:	Documentation/cdrom/
@@ -5871,7 +5797,6 @@ F:	drivers/usb/class/cdc-acm.*
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/block/ub.c
@@ -6211,7 +6136,6 @@ P:	Hans J. Koch
 M:	hjk@linutronix.de
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
@@ -6237,7 +6161,6 @@ F:	drivers/video/uvesafb.*
 VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
@@ -6342,7 +6265,6 @@ F:	drivers/hwmon/w83793.c
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
 M:	pierre@ossman.eu
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/wbsd.*
 
@@ -6429,7 +6351,6 @@ M:	mingo@redhat.com
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 M:	x86@kernel.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
 F:	Documentation/x86/
@@ -6465,7 +6386,6 @@ XILINX SYSTEMACE DRIVER
 P:	Grant Likely
 M:	grant.likely@secretlab.ca
 W:	http://www.secretlab.ca/
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/block/xsysace.c
 
@@ -6536,4 +6456,3 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Buried alive in reporters
 F:	*
 F:	*/
