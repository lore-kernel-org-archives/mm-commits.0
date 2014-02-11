From: akpm@linux-foundation.org
Subject: [merged] documentation-update-00-index-files.patch removed from
 -mm tree
Date: Tue, 11 Feb 2014 11:23:22 -0800
Message-ID: <52fa78aa.5tKoeU+D2r+GswEW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaBKTXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de, robh+dt@kernel.org, rob@landley.net, plagnioj@jcrosoft.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu, len.brown@intel.com, jkosina@suse.cz, hpa@zytor.com, gleb@kernel.org, davem@davemloft.net, broonie@kernel.org, JBottomley@parallels.com, henrik@austad.us

Subject: [merged] documentation-update-00-index-files.patch removed from -mm tree
To: henrik@austad.us,JBottomley@parallels.com,broonie@kernel.org,davem@davemloft.net,gleb@kernel.org,hpa@zytor.com,jkosina@suse.cz,len.brown@intel.com,mingo@elte.hu,paulmck@linux.vnet.ibm.com,plagnioj@jcrosoft.com,rob@landley.net,robh+dt@kernel.org,tglx@linutronix.de,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:22 -0800


The patch titled
     Subject: Documentation/: update 00-INDEX files
has been removed from the -mm tree.  Its filename was
     documentation-update-00-index-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henrik Austad <henrik@austad.us>
Subject: Documentation/: update 00-INDEX files

Some of the 00-INDEX files are somewhat outdated and some folders does not
contain 00-INDEX at all.  Only outdated (with the notably exception of
spi) indexes are touched here, the 169 folders without 00-INDEX has not
been touched.

New 00-INDEX
- spi/* was added in a series of commits dating back to 2006

Added files (missing in (*/)00-INDEX)
- dmatest.txt was added by 851b7e16 (dmatest: run test via
  debugfs).
- this_cpu_ops.txt was added by a1b2a555 (percpu: add documentation on
  this_cpu operations)
- ww-mutex-design.txt was added by 040a0a37 (mutex: Add support for
  wound/wait style locks)
- bcache.txt was added by cafe5635 (bcache: A block layer cache)
- kernel-per-CPU-kthreads.txt was added by 49717cb40 (kthread: Document
  ways of reducing OS jitter due to per-CPU kthreads).
- phy.txt was added by ff764963 (phy: add generic PHY framework)
- block/null_blk was added by 12f8f4fc (null_blk: documentation)
- module-signing.txt was added by 3cafea30 (Add
  Documentation/module-signing.txt file)
- assoc_array.txt was added by 3cb98950 (Add a generic associative array
  implementation.)
- arm/IXP4xx was part of the initial repo (1da177e4).
- arm/cluster-pm-race-avoidance.txt was added by 7fe31d28 (ARM: mcpm:
  introduce helpers for platform coherency exit/setup).
- arm/firmware.txt was added by 7366b92a (ARM: Add interface for
  registering and calling firmware-specific operations).
- arm/kernel_mode_neon.txt was added by 2afd0a05 (ARM: 7825/1: document
  the use of NEON in kernel mode)
- arm/tcm.txt was added by bc581770 (ARM: 5580/2: ARM TCM
  (Tightly-Coupled Memory) support v3)
- arm/vlocks.txt was added by 9762f12d (ARM: mcpm: Add baremetal voting mutexes)
- blackfin/gptimers-example.c, Makefile was added by 4b60779d (Blackfin:
  add an example showing how to use the gptimers API)
- devicetree/usage-model.txt was added by 31134efc (dt: Linux DT usage
  model documentation)
- fb/api.txt was added by fb21c2f4 (fbdev: Add FOURCC-based format
  configuration API)
- fb/sm501.txt was added by e6a04980 (video, sm501: add edid and
  commandline support)
- fb/udlfb.txt was added by 96f8d864 (fbdev: move udlfb out of staging.)
- filesystems/Makefile was added by 1e0051ae (Documentation/fs/: split
  txt and source files)
- filesystems/nfs/nfsd-admin-interfaces.txt was added by 8a4c6e19 (nfsd:
  document kernel interfaces for nfsd configuration)
- ide/warm-plug-howto.txt was added by f74c9141 (ide: add warm-plug
  support for IDE devices (take 2))
- laptops/Makefile was added by d49129ac (Documentation/laptop/: split
  txt and source files).
- leds/leds-blinkm.txt was added by b54cf35a (LEDS: add BlinkM RGB LED
  driver, documentation and update MAINTAINERS)
- leds/ledtrig-oneshot.txt was added by 5e417281c (leds: add oneshot
  trigger)
- leds/ledtrig-transient.txt was added by 44e1e9f8 (leds: add new
  transient trigger for one shot timer activation)
- m68k/README.buddha was part of the initial repo (1da177e4).
- networking/LICENSE.(qla3xxx|qlcnic|qlge) was added by 5a4faa87,
  40839129, c4e84bde.
- networking/Makefile was added by 3794f3e8 (docsrc: build
  Documentation/ sources)
- networking/i40evf.txt was added by 105bf2fe (i40evf: add driver to
  kernel build system)
- networking/ipsec.txt was added by b3c6efbc (xfrm: Add file to document
  IPsec corner case)
- networking/mac80211-auth-assoc-deauth.txt was added by 3cd7920a
  (mac80211: add auth/assoc/deauth flow diagram)
- networking/netlink_mmap.txt was added by 5683264c (netlink: add
  documentation for memory mapped I/O)
- networking/nf_conntrack-sysctl.txt was added by c9f9e0e1 (netfilter:
  doc: add nf_conntrack sysctl api documentation)
  lan)
- networking/team.txt was added by 3d249d4c (net: introduce ethernet
  teaming device)
- networking/vxlan.txt was added by d342894c (vxlan: virtual extensible
- power/runtime_pm.txt was added by 5e928f77 (PM: Introduce core
  framework for run-time PM of I/O devices (rev. 17))
- power/charger-manager.txt was added by 3bb3dbbd (power_supply: Add
  initial Charger-Manager driver)
- RCU/lockdep-splat.txt was added by d7bd2d68 (rcu: Document
  terpretation of RCU-lockdep splats)
- s390/kvm.txt was added by 5ecee4b (KVM: s390: API documentation)
- s390/qeth.txt was added by b4d72c08 (qeth: bridgeport support - basic
  control)
- scheduler/sched-bwc.txt was added by 88ebc08e (sched: Add
  documentation for bandwidth control)
- scsi/advansys.txt was added by 4bd6d7f3 ([SCSI] advansys: Move
  documentation to Documentation/scsi)
- scsi/bfa.txt was added by 1ec90174 ([SCSI] bfa: add readme file)
- scsi/bnx2fc.txt was added by 12b8fc10 ([SCSI] bnx2fc: Add driver
  documentation)
- scsi/cxgb3i.txt was added by c3673464 ([SCSI] cxgb3i: Add cxgb3i iSCSI
  driver.)
- scsi/hpsa.txt was added by 992ebcf1 ([SCSI] hpsa: Add hpsa.txt to
  Documentation/scsi)
- scsi/link_power_management_policy.txt was added by ca77329f ([libata]
  Link power management infrastructure)
- scsi/osd.txt was added by 78e0c621 ([SCSI] osd: Documentation for OSD
  library)
- scsi/scsi-parameter.txt was created/moved by 163475fb (Documentation:
  move SCSI parameters to their own text file)
- serial/driver was part of the initial repo (1da177e4).
- serial/n_gsm.txt was added by 323e8412 (n_gsm: add a documentation)
- timers/Makefile was added by 3794f3e (docsrc: build Documentation/
  sources)
- virt/kvm/s390.txt was added by d9101fca (KVM: s390: diagnose call
  documentation)
- vm/split_page_table_lock was added by 49076ec2 (mm: dynamically
  allocate page->ptl if it cannot be embedded to struct page)
- w1/slaves/w1_ds28e04 was added by fbf7f7b4 (w1: Add 1-wire slave
  device driver for DS28E04-100)
- w1/masters/omap-hdq was added by e0a29382 (hdq: documentation for OMAP
  HDQ)
- x86/early-microcode.txt was added by 0d91ea86 (x86, doc: Documentation
  for early microcode loading)
- x86/earlyprintk.txt was added by a1aade47 (x86/doc: mini-howto for
  using earlyprintk=dbgp)
- x86/entry_64.txt was added by 8b4777a4 (x86-64: Document some of
  entry_64.S)
- x86/pat.txt was added by d27554d8 (x86: PAT documentation)

Moved files
- arm/kernel_user_helpers.txt was moved out of arch/arm/kernel by
  37b83046 (ARM: kuser: move interface documentation out of the source
  code)
- efi-stub.txt was moved out of x86/ and down into Documentation/ in
  4172fe2f (EFI stub documentation updates)
- laptops/hpfall.c was moved out of hwmon/ and into laptops/ in efcfed9b
  (Move hp_accel to drivers/platform/x86)
- 5616c23a: 'x86: doc: move x86-generic documentation from Doc/x86/i386'
  * x86/usb-legacy-support.txt
  * x86/boot.txt
  * x86/zero_page.txt
- power/video_extension.txt was moved to acpi in 70e66e4df (ACPI /
  video: move video_extension.txt to Documentation/acpi)

Removed files (left in 00-INDEX)
- memory.txt was removed by 00ea8990 (memory.txt: remove stray
  information), but file was still listed in 00-INDEX.
- gpio.txt was moved to gpio/ in fd8e198c (gpiolib: document new
  interface)
- networking/DLINK.txt was removed by 168e06ae (drivers/net: delete old
  parallel port de600/de620 drivers)
- serial/hayes-esp.txt was removed by f53a2ade (tty: esp: remove broken
  driver)
- s390/TAPE was removed by 9e280f66 ([S390] remove tape block docu)
- vm/locking was removed by 57ea8171 (mm: documentation: remove
  hopelessly out-of-date locking doc)
- laptops/acer-wmi.txt was remvoed by 02003667 (acer-wmi: Delete
  out-of-date documentation)

Typos/misc issues
- rpc-server-gss.txt was added as knfsd-rpcgss.txt in 030d794b (SUNRPC:
  Use gssproxy upcall for server RPCGSS authentication)
- b88cf73d (net: add missing entries to Documentation/networking/00-INDEX):
  * generic-hdlc.txt was added as generic_hdlc.txt
  * spider_net.txt was added as spider-net.txt
- w1/master/mxc-w1 was added as mxc_w1 by a5fd9139 (w1: add 1-wire
  master driver for i.MX27 / i.MX31)
- s390/zfcpdump.txt was added as zfcpdump by 6920c12 ([S390] Add
  Documentation/s390/00-INDEX).

Signed-off-by: Henrik Austad <henrik@austad.us>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>	[rcu bits]
Acked-by: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX                 |   24 +++++++++++++++---
 Documentation/RCU/00-INDEX             |    2 +
 Documentation/arm/00-INDEX             |   14 ++++++++++
 Documentation/blackfin/00-INDEX        |    6 +++-
 Documentation/block/00-INDEX           |    2 +
 Documentation/devicetree/00-INDEX      |    2 +
 Documentation/fb/00-INDEX              |    6 ++++
 Documentation/filesystems/00-INDEX     |    2 +
 Documentation/filesystems/nfs/00-INDEX |    4 ++-
 Documentation/ide/00-INDEX             |    2 +
 Documentation/laptops/00-INDEX         |    6 +++-
 Documentation/leds/00-INDEX            |    8 ++++++
 Documentation/m68k/00-INDEX            |    2 +
 Documentation/networking/00-INDEX      |   30 +++++++++++++++++++----
 Documentation/power/00-INDEX           |    6 +++-
 Documentation/s390/00-INDEX            |    8 +++---
 Documentation/scheduler/00-INDEX       |    2 +
 Documentation/scsi/00-INDEX            |   16 ++++++++++++
 Documentation/serial/00-INDEX          |    6 +++-
 Documentation/spi/00-INDEX             |   22 ++++++++++++++++
 Documentation/timers/00-INDEX          |    2 +
 Documentation/virtual/kvm/00-INDEX     |    2 +
 Documentation/vm/00-INDEX              |    4 +--
 Documentation/w1/masters/00-INDEX      |    4 ++-
 Documentation/w1/slaves/00-INDEX       |    2 +
 Documentation/x86/00-INDEX             |   18 ++++++++++++-
 26 files changed, 176 insertions(+), 26 deletions(-)

diff -puN Documentation/00-INDEX~documentation-update-00-index-files Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/00-INDEX
@@ -29,6 +29,8 @@ DMA-ISA-LPC.txt
 	- How to do DMA with ISA (and LPC) devices.
 DMA-attributes.txt
 	- listing of the various possible attributes a DMA region can have
+dmatest.txt
+	- how to compile, configure and use the dmatest system.
 DocBook/
 	- directory with DocBook templates etc. for kernel documentation.
 EDID/
@@ -77,6 +79,8 @@ arm/
 	- directory with info about Linux on the ARM architecture.
 arm64/
 	- directory with info about Linux on the 64 bit ARM architecture.
+assoc_array.txt
+	- generic associative array intro.
 atomic_ops.txt
 	- semantics and behavior of atomic and bitmask operations.
 auxdisplay/
@@ -87,6 +91,8 @@ bad_memory.txt
 	- how to use kernel parameters to exclude bad RAM regions.
 basic_profiling.txt
 	- basic instructions for those who wants to profile Linux kernel.
+bcache.txt
+	- Block-layer cache on fast SSDs to improve slow (raid) I/O performance.
 binfmt_misc.txt
 	- info on the kernel support for extra binary formats.
 blackfin/
@@ -171,6 +177,8 @@ early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
 edac.txt
 	- information on EDAC - Error Detection And Correction
+efi-stub.txt
+	- How to use the EFI boot stub to bypass GRUB or elilo on EFI systems.
 eisa.txt
 	- info on EISA bus support.
 email-clients.txt
@@ -195,8 +203,8 @@ futex-requeue-pi.txt
 	- info on requeueing of tasks from a non-PI futex to a PI futex
 gcov.txt
 	- use of GCC's coverage testing tool "gcov" with the Linux kernel
-gpio.txt
-	- overview of GPIO (General Purpose Input/Output) access conventions.
+gpio/
+	- gpio related documentation
 hid/
 	- directory with information on human interface devices
 highuid.txt
@@ -255,6 +263,8 @@ kernel-docs.txt
 	- listing of various WWW + books that document kernel internals.
 kernel-parameters.txt
 	- summary listing of command line / boot prompt args for the kernel.
+kernel-per-CPU-kthreads.txt
+	- List of all per-CPU kthreads and how they introduce jitter.
 kmemcheck.txt
 	- info on dynamic checker that detects uses of uninitialized memory.
 kmemleak.txt
@@ -299,8 +309,6 @@ memory-devices/
 	- directory with info on parts like the Texas Instruments EMIF driver
 memory-hotplug.txt
 	- Hotpluggable memory support, how to use and current status.
-memory.txt
-	- info on typical Linux memory problems.
 metag/
 	- directory with info about Linux on Meta architecture.
 mips/
@@ -311,6 +319,8 @@ mmc/
 	- directory with info about the MMC subsystem
 mn10300/
 	- directory with info about the mn10300 architecture port
+module-signing.txt
+	- Kernel module signing for increased security when loading modules.
 mtd/
 	- directory with info about memory technology devices (flash)
 mono.txt
@@ -343,6 +353,8 @@ pcmcia/
 	- info on the Linux PCMCIA driver.
 percpu-rw-semaphore.txt
 	- RCU based read-write semaphore optimized for locking for reading
+phy.txt
+	- Description of the generic PHY framework.
 pi-futex.txt
 	- documentation on lightweight priority inheritance futexes.
 pinctrl.txt
@@ -431,6 +443,8 @@ sysrq.txt
 	- info on the magic SysRq key.
 target/
 	- directory with info on generating TCM v4 fabric .ko modules
+this_cpu_ops.txt
+	- List rationale behind and the way to use this_cpu operations.
 thermal/
 	- directory with information on managing thermal issues (CPU/temp)
 trace/
@@ -469,6 +483,8 @@ wimax/
 	- directory with info about Intel Wireless Wimax Connections
 workqueue.txt
 	- information on the Concurrency Managed Workqueue implementation
+ww-mutex-design.txt
+	- Intro to Mutex wait/would deadlock handling.s
 x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
 xtensa/
diff -puN Documentation/RCU/00-INDEX~documentation-update-00-index-files Documentation/RCU/00-INDEX
--- a/Documentation/RCU/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/RCU/00-INDEX
@@ -8,6 +8,8 @@ listRCU.txt
 	- Using RCU to Protect Read-Mostly Linked Lists
 lockdep.txt
 	- RCU and lockdep checking
+lockdep-splat.txt
+	- RCU Lockdep splats explained.
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
 rcubarrier.txt
diff -puN Documentation/arm/00-INDEX~documentation-update-00-index-files Documentation/arm/00-INDEX
--- a/Documentation/arm/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/arm/00-INDEX
@@ -4,6 +4,8 @@ Booting
 	- requirements for booting
 Interrupts
 	- ARM Interrupt subsystem documentation
+IXP4xx
+	- Intel IXP4xx Network processor.
 msm
 	- MSM specific documentation
 Netwinder
@@ -24,8 +26,16 @@ SPEAr
 	- ST SPEAr platform Linux Overview
 VFP/
 	- Release notes for Linux Kernel Vector Floating Point support code
+cluster-pm-race-avoidance.txt
+	- Algorithm for CPU and Cluster setup/teardown
 empeg/
 	- Ltd's Empeg MP3 Car Audio Player
+firmware.txt
+	- Secure firmware registration and calling.
+kernel_mode_neon.txt
+	- How to use NEON instructions in kernel mode
+kernel_user_helpers.txt
+	- Helper functions in kernel space made available for userspace.
 mem_alignment
 	- alignment abort handler documentation
 memory.txt
@@ -34,3 +44,7 @@ nwfpe/
 	- NWFPE floating point emulator documentation
 swp_emulation
 	- SWP/SWPB emulation handler/logging description
+tcm.txt
+	- ARM Tightly Coupled Memory
+vlocks.txt
+	- Voting locks, low-level mechanism relying on memory system atomic writes.
diff -puN Documentation/blackfin/00-INDEX~documentation-update-00-index-files Documentation/blackfin/00-INDEX
--- a/Documentation/blackfin/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/blackfin/00-INDEX
@@ -1,8 +1,10 @@
 00-INDEX
 	- This file
-
+Makefile
+	- Makefile for gptimers example file.
 bfin-gpio-notes.txt
 	- Notes in developing/using bfin-gpio driver.
-
 bfin-spi-notes.txt
 	- Notes for using bfin spi bus driver.
+gptimers-example.c
+	- gptimers example
diff -puN Documentation/block/00-INDEX~documentation-update-00-index-files Documentation/block/00-INDEX
--- a/Documentation/block/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/block/00-INDEX
@@ -14,6 +14,8 @@ deadline-iosched.txt
 	- Deadline IO scheduler tunables
 ioprio.txt
 	- Block io priorities (in CFQ scheduler)
+null_blk.txt
+	- Null block for block-layer benchmarking.
 queue-sysfs.txt
 	- Queue's sysfs entries
 request.txt
diff -puN Documentation/devicetree/00-INDEX~documentation-update-00-index-files Documentation/devicetree/00-INDEX
--- a/Documentation/devicetree/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/devicetree/00-INDEX
@@ -8,3 +8,5 @@ https://lists.ozlabs.org/listinfo/device
 	- this file
 booting-without-of.txt
 	- Booting Linux without Open Firmware, describes history and format of device trees.
+usage-model.txt
+	- How Linux uses DT and what DT aims to solve.
\ No newline at end of file
diff -puN Documentation/fb/00-INDEX~documentation-update-00-index-files Documentation/fb/00-INDEX
--- a/Documentation/fb/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/fb/00-INDEX
@@ -5,6 +5,8 @@ please mail me.
 
 00-INDEX
 	- this file.
+api.txt
+	- The frame buffer API between applications and buffer devices.
 arkfb.txt
 	- info on the fbdev driver for ARK Logic chips.
 aty128fb.txt
@@ -51,12 +53,16 @@ sh7760fb.txt
 	- info on the SH7760/SH7763 integrated LCDC Framebuffer driver.
 sisfb.txt
 	- info on the framebuffer device driver for various SiS chips.
+sm501.txt
+	- info on the framebuffer device driver for sm501 videoframebuffer.
 sstfb.txt
 	- info on the frame buffer driver for 3dfx' Voodoo Graphics boards.
 tgafb.txt
 	- info on the TGA (DECChip 21030) frame buffer driver.
 tridentfb.txt
 	info on the framebuffer driver for some Trident chip based cards.
+udlfb.txt
+	- Driver for DisplayLink USB 2.0 chips.
 uvesafb.txt
 	- info on the userspace VESA (VBE2+ compliant) frame buffer device.
 vesafb.txt
diff -puN Documentation/filesystems/00-INDEX~documentation-update-00-index-files Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/filesystems/00-INDEX
@@ -2,6 +2,8 @@
 	- this file (info on some of the filesystems supported by linux).
 Locking
 	- info on locking rules as they pertain to Linux VFS.
+Makefile
+	- Makefile for building the filsystems-part of DocBook.
 9p.txt
 	- 9p (v9fs) is an implementation of the Plan 9 remote fs protocol.
 adfs.txt
diff -puN Documentation/filesystems/nfs/00-INDEX~documentation-update-00-index-files Documentation/filesystems/nfs/00-INDEX
--- a/Documentation/filesystems/nfs/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/filesystems/nfs/00-INDEX
@@ -12,6 +12,8 @@ nfs41-server.txt
 	- info on the Linux server implementation of NFSv4 minor version 1.
 nfs-rdma.txt
 	- how to install and setup the Linux NFS/RDMA client and server software
+nfsd-admin-interfaces.txt
+	- Administrative interfaces for nfsd.
 nfsroot.txt
 	- short guide on setting up a diskless box with NFS root filesystem.
 pnfs.txt
@@ -20,5 +22,5 @@ rpc-cache.txt
 	- introduction to the caching mechanisms in the sunrpc layer.
 idmapper.txt
 	- information for configuring request-keys to be used by idmapper
-knfsd-rpcgss.txt
+rpc-server-gss.txt
 	- Information on GSS authentication support in the NFS Server
diff -puN Documentation/ide/00-INDEX~documentation-update-00-index-files Documentation/ide/00-INDEX
--- a/Documentation/ide/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/ide/00-INDEX
@@ -10,3 +10,5 @@ ide-tape.txt
 	- info on the IDE ATAPI streaming tape driver
 ide.txt
 	- important info for users of ATA devices (IDE/EIDE disks and CD-ROMS).
+warm-plug-howto.txt
+	- using sysfs to remove and add IDE devices.
\ No newline at end of file
diff -puN Documentation/laptops/00-INDEX~documentation-update-00-index-files Documentation/laptops/00-INDEX
--- a/Documentation/laptops/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/laptops/00-INDEX
@@ -1,13 +1,15 @@
 00-INDEX
 	- This file
-acer-wmi.txt
-	- information on the Acer Laptop WMI Extras driver.
+Makefile
+	- Makefile for building dslm example program.
 asus-laptop.txt
 	- information on the Asus Laptop Extras driver.
 disk-shock-protection.txt
 	- information on hard disk shock protection.
 dslm.c
 	- Simple Disk Sleep Monitor program
+hpfall.c
+	- (HP) laptop accelerometer program for disk protection.
 laptop-mode.txt
 	- how to conserve battery power using laptop-mode.
 sony-laptop.txt
diff -puN Documentation/leds/00-INDEX~documentation-update-00-index-files Documentation/leds/00-INDEX
--- a/Documentation/leds/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/leds/00-INDEX
@@ -1,3 +1,7 @@
+00-INDEX
+	- This file
+leds-blinkm.txt
+	- Driver for BlinkM LED-devices.
 leds-class.txt
 	- documents LED handling under Linux.
 leds-lp3944.txt
@@ -12,3 +16,7 @@ leds-lp55xx.txt
 	- description about lp55xx common driver.
 leds-lm3556.txt
 	- notes on how to use the leds-lm3556 driver.
+ledtrig-oneshot.txt
+	- One-shot LED trigger for both sporadic and dense events.
+ledtrig-transient.txt
+	- LED Transient Trigger, one shot timer activation.
diff -puN Documentation/m68k/00-INDEX~documentation-update-00-index-files Documentation/m68k/00-INDEX
--- a/Documentation/m68k/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/m68k/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- this file
+README.buddha
+	- Amiga Buddha and Catweasel IDE Driver
 kernel-options.txt
 	- command line options for Linux/m68k
 
diff -puN Documentation/networking/00-INDEX~documentation-update-00-index-files Documentation/networking/00-INDEX
--- a/Documentation/networking/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/networking/00-INDEX
@@ -6,8 +6,14 @@
 	- information on the 3Com Etherlink III Series Ethernet cards.
 6pack.txt
 	- info on the 6pack protocol, an alternative to KISS for AX.25
-DLINK.txt
-	- info on the D-Link DE-600/DE-620 parallel port pocket adapters
+LICENSE.qla3xxx
+	- GPLv2 for QLogic Linux Networking HBA Driver
+LICENSE.qlge
+	- GPLv2 for QLogic Linux qlge NIC Driver
+LICENSE.qlcnic
+	- GPLv2 for QLogic Linux qlcnic NIC Driver
+Makefile
+	- Makefile for docsrc.
 PLIP.txt
 	- PLIP: The Parallel Line Internet Protocol device driver
 README.ipw2100
@@ -17,7 +23,7 @@ README.ipw2200
 README.sb1000
 	- info on General Instrument/NextLevel SURFboard1000 cable modem.
 alias.txt
-	- info on using alias network devices 
+	- info on using alias network devices.
 arcnet-hardware.txt
 	- tons of info on ARCnet, hubs, jumper settings for ARCnet cards, etc.
 arcnet.txt
@@ -80,7 +86,7 @@ framerelay.txt
 	- info on using Frame Relay/Data Link Connection Identifier (DLCI).
 gen_stats.txt
 	- Generic networking statistics for netlink users.
-generic_hdlc.txt
+generic-hdlc.txt
 	- The generic High Level Data Link Control (HDLC) layer.
 generic_netlink.txt
 	- info on Generic Netlink
@@ -88,6 +94,8 @@ gianfar.txt
 	- Gianfar Ethernet Driver.
 i40e.txt
 	- README for the Intel Ethernet Controller XL710 Driver (i40e).
+i40evf.txt
+	- Short note on the Driver for the Intel(R) XL710 X710 Virtual Function
 ieee802154.txt
 	- Linux IEEE 802.15.4 implementation, API and drivers
 igb.txt
@@ -102,6 +110,8 @@ ipddp.txt
 	- AppleTalk-IP Decapsulation and AppleTalk-IP Encapsulation
 iphase.txt
 	- Interphase PCI ATM (i)Chip IA Linux driver info.
+ipsec.txt
+	- Note on not compressing IPSec payload and resulting failed policy check.
 ipv6.txt
 	- Options to the ipv6 kernel module.
 ipvs-sysctl.txt
@@ -120,6 +130,8 @@ lapb-module.txt
 	- programming information of the LAPB module.
 ltpc.txt
 	- the Apple or Farallon LocalTalk PC card driver
+mac80211-auth-assoc-deauth.txt
+	- authentication and association / deauth-disassoc with max80211
 mac80211-injection.txt
 	- HOWTO use packet injection with mac80211
 multiqueue.txt
@@ -134,6 +146,10 @@ netdevices.txt
 	- info on network device driver functions exported to the kernel.
 netif-msg.txt
 	- Design of the network interface message level setting (NETIF_MSG_*).
+netlink_mmap.txt
+	- memory mapped I/O with netlink
+nf_conntrack-sysctl.txt
+	- list of netfilter-sysctl knobs.
 nfc.txt
 	- The Linux Near Field Communication (NFS) subsystem.
 openvswitch.txt
@@ -176,7 +192,7 @@ skfp.txt
 	- SysKonnect FDDI (SK-5xxx, Compaq Netelligent) driver info.
 smc9.txt
 	- the driver for SMC's 9000 series of Ethernet cards
-spider-net.txt
+spider_net.txt
 	- README for the Spidernet Driver (as found in PS3 / Cell BE).
 stmmac.txt
 	- README for the STMicro Synopsys Ethernet driver.
@@ -188,6 +204,8 @@ tcp.txt
 	- short blurb on how TCP output takes place.
 tcp-thin.txt
 	- kernel tuning options for low rate 'thin' TCP streams.
+team.txt
+	- pointer to information for ethernet teaming devices.
 tlan.txt
 	- ThunderLAN (Compaq Netelligent 10/100, Olicom OC-2xxx) driver info.
 tproxy.txt
@@ -200,6 +218,8 @@ vortex.txt
 	- info on using 3Com Vortex (3c590, 3c592, 3c595, 3c597) Ethernet cards.
 vxge.txt
 	- README for the Neterion X3100 PCIe Server Adapter.
+vxlan.txt
+	- Virtual extensible LAN overview
 x25.txt
 	- general info on X.25 development.
 x25-iface.txt
diff -puN Documentation/power/00-INDEX~documentation-update-00-index-files Documentation/power/00-INDEX
--- a/Documentation/power/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/power/00-INDEX
@@ -4,6 +4,8 @@ apm-acpi.txt
 	- basic info about the APM and ACPI support.
 basic-pm-debugging.txt
 	- Debugging suspend and resume
+charger-manager.txt
+	- Battery charger management.
 devices.txt
 	- How drivers interact with system-wide power management
 drivers-testing.txt
@@ -22,6 +24,8 @@ pm_qos_interface.txt
 	- info on Linux PM Quality of Service interface
 power_supply_class.txt
 	- Tells userspace about battery, UPS, AC or DC power supply properties
+runtime_pm.txt
+	- Power management framework for I/O devices.
 s2ram.txt
 	- How to get suspend to ram working (and debug it when it isn't)
 states.txt
@@ -38,7 +42,5 @@ tricks.txt
 	- How to trick software suspend (to disk) into working when it isn't
 userland-swsusp.txt
 	- Experimental implementation of software suspend in userspace
-video_extension.txt
-	- ACPI video extensions
 video.txt
 	- Video issues during resume from suspend
diff -puN Documentation/s390/00-INDEX~documentation-update-00-index-files Documentation/s390/00-INDEX
--- a/Documentation/s390/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/s390/00-INDEX
@@ -16,11 +16,13 @@ Debugging390.txt
 	- hints for debugging on s390 systems.
 driver-model.txt
 	- information on s390 devices and the driver model.
+kvm.txt
+	- ioctl calls to /dev/kvm on s390.
 monreader.txt
 	- information on accessing the z/VM monitor stream from Linux.
+qeth.txt
+	- HiperSockets Bridge Port Support.
 s390dbf.txt
 	- information on using the s390 debug feature.
-TAPE
-	- information on the driver for channel-attached tapes.
-zfcpdump
+zfcpdump.txt
 	- information on the s390 SCSI dump tool.
diff -puN Documentation/scheduler/00-INDEX~documentation-update-00-index-files Documentation/scheduler/00-INDEX
--- a/Documentation/scheduler/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/scheduler/00-INDEX
@@ -2,6 +2,8 @@
 	- this file.
 sched-arch.txt
 	- CPU Scheduler implementation hints for architecture specific code.
+sched-bwc.txt
+	- CFS bandwidth control overview.
 sched-design-CFS.txt
 	- goals, design and implementation of the Completely Fair Scheduler.
 sched-domains.txt
diff -puN Documentation/scsi/00-INDEX~documentation-update-00-index-files Documentation/scsi/00-INDEX
--- a/Documentation/scsi/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/scsi/00-INDEX
@@ -36,6 +36,8 @@ NinjaSCSI.txt
 	- info on WorkBiT NinjaSCSI-32/32Bi driver
 aacraid.txt
 	- Driver supporting Adaptec RAID controllers
+advansys.txt
+	- List of Advansys Host Adapters
 aha152x.txt
 	- info on driver for Adaptec AHA152x based adapters
 aic79xx.txt
@@ -44,6 +46,12 @@ aic7xxx.txt
 	- info on driver for Adaptec controllers
 arcmsr_spec.txt
 	- ARECA FIRMWARE SPEC (for IOP331 adapter)
+bfa.txt
+	- Brocade FC/FCOE adapter driver.
+bnx2fc.txt
+	- FCoE hardware offload for Broadcom network interfaces.
+cxgb3i.txt
+	- Chelsio iSCSI Linux Driver
 dc395x.txt
 	- README file for the dc395x SCSI driver
 dpti.txt
@@ -52,18 +60,24 @@ dtc3x80.txt
 	- info on driver for DTC 2x80 based adapters
 g_NCR5380.txt
 	- info on driver for NCR5380 and NCR53c400 based adapters
+hpsa.txt
+	- HP Smart Array Controller SCSI driver.
 hptiop.txt
 	- HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 in2000.txt
 	- info on in2000 driver
 libsas.txt
 	- Serial Attached SCSI management layer.
+link_power_management_policy.txt
+	- Link power management options.
 lpfc.txt
 	- LPFC driver release notes
 megaraid.txt
 	- Common Management Module, shared code handling ioctls for LSI drivers
 ncr53c8xx.txt
 	- info on driver for NCR53c8xx based adapters
+osd.txt
+	Object-Based Storage Device, command set introduction.
 osst.txt
 	- info on driver for OnStream SC-x0 SCSI tape
 ppa.txt
@@ -74,6 +88,8 @@ scsi-changer.txt
 	- README for the SCSI media changer driver
 scsi-generic.txt
 	- info on the sg driver for generic (non-disk/CD/tape) SCSI devices.
+scsi-parameters.txt
+	- List of SCSI-parameters to pass to the kernel at module load-time.
 scsi.txt
 	- short blurb on using SCSI support as a module.
 scsi_mid_low_api.txt
diff -puN Documentation/serial/00-INDEX~documentation-update-00-index-files Documentation/serial/00-INDEX
--- a/Documentation/serial/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/serial/00-INDEX
@@ -4,10 +4,12 @@ README.cycladesZ
 	- info on Cyclades-Z firmware loading.
 digiepca.txt
 	- info on Digi Intl. {PC,PCI,EISA}Xx and Xem series cards.
-hayes-esp.txt
-	- info on using the Hayes ESP serial driver.
+driver
+	- intro to the low level serial driver.
 moxa-smartio
 	- file with info on installing/using Moxa multiport serial driver.
+n_gsm.txt
+	- GSM 0710 tty multiplexer howto.
 riscom8.txt
 	- notes on using the RISCom/8 multi-port serial driver.
 rocket.txt
diff -puN /dev/null Documentation/spi/00-INDEX
--- /dev/null
+++ a/Documentation/spi/00-INDEX
@@ -0,0 +1,22 @@
+00-INDEX
+	- this file.
+Makefile
+	- Makefile for the example sourcefiles.
+butterfly
+	- AVR Butterfly SPI driver overview and pin configuration.
+ep93xx_spi
+	- Basic EP93xx SPI driver configuration.
+pxa2xx
+	- PXA2xx SPI master controller build by spi_message fifo wq
+spidev
+	- Intro to the userspace API for spi devices
+spidev_fdx.c
+	- spidev example file
+spi-lm70llp
+	- Connecting an LM70-LLP sensor to the kernel via the SPI subsys.
+spi-sc18is602
+	- NXP SC18IS602/603 I2C-bus to SPI bridge
+spi-summary
+	- (Linux) SPI overview. If unsure about SPI or SPI in Linux, start here.
+spidev_test.c
+	- SPI testing utility.
diff -puN Documentation/timers/00-INDEX~documentation-update-00-index-files Documentation/timers/00-INDEX
--- a/Documentation/timers/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/timers/00-INDEX
@@ -8,6 +8,8 @@ hpet_example.c
 	- sample hpet timer test program
 hrtimers.txt
 	- subsystem for high-resolution kernel timers
+Makefile
+	- Build and link hpet_example
 NO_HZ.txt
 	- Summary of the different methods for the scheduler clock-interrupts management.
 timers-howto.txt
diff -puN Documentation/virtual/kvm/00-INDEX~documentation-update-00-index-files Documentation/virtual/kvm/00-INDEX
--- a/Documentation/virtual/kvm/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/virtual/kvm/00-INDEX
@@ -20,5 +20,7 @@ ppc-pv.txt
 	- the paravirtualization interface on PowerPC.
 review-checklist.txt
 	- review checklist for KVM patches.
+s390-diag.txt
+	- Diagnose hypercall description (for IBM S/390)
 timekeeping.txt
 	- timekeeping virtualization for x86-based architectures.
diff -puN Documentation/vm/00-INDEX~documentation-update-00-index-files Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/vm/00-INDEX
@@ -16,8 +16,6 @@ hwpoison.txt
 	- explains what hwpoison is
 ksm.txt
 	- how to use the Kernel Samepage Merging feature.
-locking
-	- info on how locking and synchronization is done in the Linux vm code.
 numa
 	- information about NUMA specific code in the Linux vm.
 numa_memory_policy.txt
@@ -32,6 +30,8 @@ slub.txt
 	- a short users guide for SLUB.
 soft-dirty.txt
 	- short explanation for soft-dirty PTEs
+split_page_table_lock
+	- Separate per-table lock to improve scalability of the old page_table_lock.
 transhuge.txt
 	- Transparent Hugepage Support, alternative way of using hugepages.
 unevictable-lru.txt
diff -puN Documentation/w1/masters/00-INDEX~documentation-update-00-index-files Documentation/w1/masters/00-INDEX
--- a/Documentation/w1/masters/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/w1/masters/00-INDEX
@@ -4,7 +4,9 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
-mxc_w1
+mxc-w1
 	- W1 master controller driver found on Freescale MX2/MX3 SoCs
+omap-hdq
+	- HDQ/1-wire module of TI OMAP 2430/3430.
 w1-gpio
 	- GPIO 1-wire bus master driver.
diff -puN Documentation/w1/slaves/00-INDEX~documentation-update-00-index-files Documentation/w1/slaves/00-INDEX
--- a/Documentation/w1/slaves/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/w1/slaves/00-INDEX
@@ -4,3 +4,5 @@ w1_therm
 	- The Maxim/Dallas Semiconductor ds18*20 temperature sensor.
 w1_ds2423
 	- The Maxim/Dallas Semiconductor ds2423 counter device.
+w1_ds28e04
+	- The Maxim/Dallas Semiconductor ds28e04 eeprom.
diff -puN Documentation/x86/00-INDEX~documentation-update-00-index-files Documentation/x86/00-INDEX
--- a/Documentation/x86/00-INDEX~documentation-update-00-index-files
+++ a/Documentation/x86/00-INDEX
@@ -1,6 +1,20 @@
 00-INDEX
 	- this file
-mtrr.txt
-	- how to use x86 Memory Type Range Registers to increase performance
+boot.txt
+	- List of boot protocol versions
+early-microcode.txt
+	- How to load microcode from an initrd-CPIO archive early to fix CPU issues.
+earlyprintk.txt
+	- Using earlyprintk with a USB2 debug port key.
+entry_64.txt
+	- Describe (some of the) kernel entry points for x86.
 exception-tables.txt
 	- why and how Linux kernel uses exception tables on x86
+mtrr.txt
+	- how to use x86 Memory Type Range Registers to increase performance
+pat.txt
+	- Page Attribute Table intro and API
+usb-legacy-support.txt
+	- how to fix/avoid quirks when using emulated PS/2 mouse/keyboard.
+zero-page.txt
+	- layout of the first page of memory.
_

Patches currently in -mm which might be from henrik@austad.us are

origin.patch

