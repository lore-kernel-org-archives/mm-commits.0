From: akpm@linux-foundation.org
Subject: - remove-documentation-smptxt.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:19 -0800
Message-ID: <200802050254.m152s04f031549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbYBECyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     remove Documentation/smp.txt
has been removed from the -mm tree.  Its filename was
     remove-documentation-smptxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove Documentation/smp.txt
From: Adrian Bunk <bunk@kernel.org>

After seeing the filename I'd have expected something about the
implementation of SMP in the Linux kernel - not some notes on kernel
configuration and building trivialities noone would search at this place.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX |    2 --
 Documentation/smp.txt  |   22 ----------------------
 2 files changed, 24 deletions(-)

diff -puN Documentation/00-INDEX~remove-documentation-smptxt Documentation/00-INDEX
--- a/Documentation/00-INDEX~remove-documentation-smptxt
+++ a/Documentation/00-INDEX
@@ -367,8 +367,6 @@ sharedsubtree.txt
 	- a description of shared subtrees for namespaces.
 smart-config.txt
 	- description of the Smart Config makefile feature.
-smp.txt
-	- a few notes on symmetric multi-processing.
 sony-laptop.txt
 	- Sony Notebook Control Driver (SNC) Readme.
 sonypi.txt
diff -puN Documentation/smp.txt~remove-documentation-smptxt /dev/null
--- a/Documentation/smp.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-To set up SMP
-
-Configure the kernel and answer Y to CONFIG_SMP.
-
-If you are using LILO, it is handy to have both SMP and non-SMP
-kernel images on hand. Edit /etc/lilo.conf to create an entry
-for another kernel image called "linux-smp" or something.
-
-The next time you compile the kernel, when running a SMP kernel,
-edit linux/Makefile and change "MAKE=make" to "MAKE=make -jN"
-(where N = number of CPU + 1, or if you have tons of memory/swap
- you can just use "-j" without a number). Feel free to experiment
-with this one.
-
-Of course you should time how long each build takes :-)
-Example:
-   make config
-   time -v sh -c 'make clean install modules modules_install'
-
-If you are using some Compaq MP compliant machines you will need to set
-the operating system in the BIOS settings to "Unixware" - don't ask me
-why Compaqs don't work otherwise.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
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
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
git-xtensa.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
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
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
