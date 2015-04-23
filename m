From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 23 Apr 2015 12:54:17 -0700
Message-ID: <55394de9.Yx8NJuonw7NRs79E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030497AbbDWTyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 15:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile |    4 ----
 MAINTAINERS            |    7 -------
 drivers/bus/Makefile   |    6 ------
 3 files changed, 17 deletions(-)

diff -puN Documentation/Makefile~linux-next-git-rejects Documentation/Makefile
--- a/Documentation/Makefile~linux-next-git-rejects
+++ a/Documentation/Makefile
@@ -1,8 +1,4 @@
 subdir-y := accounting auxdisplay blackfin connector \
-<<<<<<< HEAD
-	filesystems filesystems ia64 laptops mic misc-devices \
-=======
 	filesystems filesystems ia64 kdbus laptops mic misc-devices \
->>>>>>> linux-next/akpm-base
 	networking pcmcia prctl ptp spi timers vDSO video4linux \
 	watchdog
diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -1323,18 +1323,11 @@ L:	linux-soc@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-qcom/
 F:	drivers/soc/qcom/
-<<<<<<< HEAD
-=======
 F:	drivers/firmware/qcom_scm.c
->>>>>>> linux-next/akpm-base
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
 F:	drivers/mfd/ssbi.c
-<<<<<<< HEAD
-F:	drivers/firmware/qcom_scm.c
-=======
->>>>>>> linux-next/akpm-base
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
diff -puN drivers/bus/Makefile~linux-next-git-rejects drivers/bus/Makefile
--- a/drivers/bus/Makefile~linux-next-git-rejects
+++ a/drivers/bus/Makefile
@@ -7,15 +7,9 @@ obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
 obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o
 
 obj-$(CONFIG_BRCMSTB_GISB_ARB)	+= brcmstb_gisb.o
-<<<<<<< HEAD
-obj-$(CONFIG_IMX_WEIM)		+= imx-weim.o
-obj-$(CONFIG_MIPS_CDMM)		+= mips_cdmm.o
-obj-$(CONFIG_MVEBU_MBUS) 	+= mvebu-mbus.o
-=======
 obj-$(CONFIG_IMX_WEIM)	+= imx-weim.o
 obj-$(CONFIG_MIPS_CDMM) += mips_cdmm.o
 obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
->>>>>>> linux-next/akpm-base
 
 # Interconnect bus driver for OMAP SoCs.
 obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

