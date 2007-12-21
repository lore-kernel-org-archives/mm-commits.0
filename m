From: akpm@linux-foundation.org
Subject: - kconfig-help-dont-refer-to-the-pci-howto.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:25 -0800
Message-ID: <200712212208.lBLM8PZW001708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563AbXLUWJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Kconfig help: don't refer to the PCI-HOWTO
has been removed from the -mm tree.  Its filename was
     kconfig-help-dont-refer-to-the-pci-howto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kconfig help: don't refer to the PCI-HOWTO
From: Adrian Bunk <bunk@kernel.org>

A HOWTO that hasn't been updated for half a dozen years no longer "contains
valuable information about which PCI hardware does work under Linux and
which doesn't".

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig          |    5 -----
 arch/arm/Kconfig            |    5 -----
 arch/frv/Kconfig            |    5 -----
 arch/m32r/Kconfig           |    5 -----
 arch/m68k/Kconfig           |    5 -----
 arch/mips/Kconfig           |    5 -----
 arch/sh/drivers/pci/Kconfig |    5 -----
 arch/sh64/Kconfig           |    5 -----
 arch/sparc64/Kconfig        |    5 -----
 arch/x86/Kconfig            |    5 -----
 arch/xtensa/Kconfig         |    5 -----
 11 files changed, 55 deletions(-)

diff -puN arch/alpha/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/alpha/Kconfig
@@ -318,11 +318,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	bool
 	default y
diff -puN arch/arm/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/arm/Kconfig
@@ -547,11 +547,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_SYSCALL
 	def_bool PCI
 
diff -puN arch/frv/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/frv/Kconfig
--- a/arch/frv/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/frv/Kconfig
@@ -322,11 +322,6 @@ config PCI
 	  onboard. If you have one of these boards and you wish to use the PCI
 	  facilities, say Y here.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config RESERVE_DMA_COHERENT
 	bool "Reserve DMA coherent memory"
 	depends on PCI && !MMU
diff -puN arch/m32r/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/m32r/Kconfig
@@ -354,11 +354,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 choice
 	prompt "PCI access mode"
 	depends on PCI
diff -puN arch/m68k/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/m68k/Kconfig
@@ -145,11 +145,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config MAC
 	bool "Macintosh support"
 	depends on !MMU_SUN3
diff -puN arch/mips/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/mips/Kconfig
--- a/arch/mips/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/mips/Kconfig
@@ -1933,11 +1933,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, or VESA. If you have PCI,
 	  say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	bool
 
diff -puN arch/sh64/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/sh64/Kconfig
@@ -247,11 +247,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config SH_PCIDMA_NONCOHERENT
 	bool "Cache and PCI noncoherent"
 	depends on PCI
diff -puN arch/sh/drivers/pci/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/sh/drivers/pci/Kconfig
--- a/arch/sh/drivers/pci/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/sh/drivers/pci/Kconfig
@@ -6,11 +6,6 @@ config PCI
 	  bus system, i.e. the way the CPU talks to the other stuff inside
 	  your box. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config SH_PCIDMA_NONCOHERENT
 	bool "Cache and PCI noncoherent"
 	depends on PCI
diff -puN arch/sparc64/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/sparc64/Kconfig
@@ -343,11 +343,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	def_bool PCI
 
diff -puN arch/x86/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/x86/Kconfig
@@ -1389,11 +1389,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 choice
 	prompt "PCI access mode"
 	depends on X86_32 && PCI && !X86_VISWS
diff -puN arch/xtensa/Kconfig~kconfig-help-dont-refer-to-the-pci-howto arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~kconfig-help-dont-refer-to-the-pci-howto
+++ a/arch/xtensa/Kconfig
@@ -174,11 +174,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't
-
 source "drivers/pci/Kconfig"
 
 config HOTPLUG
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
scsi-megaraidc-__devexit-annotation.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
xen-fiddle_vdso-must-be-__init.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
