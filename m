From: akpm@linux-foundation.org
Subject: - xtensa-kernel-setupc-remove-dead-code.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:22:26 -0800
Message-ID: <200712102322.lBANMQG0024333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbXLJXXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:23:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa/kernel/setup.c: remove dead code
has been removed from the -mm tree.  Its filename was
     xtensa-kernel-setupc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xtensa/kernel/setup.c: remove dead code
From: Adrian Bunk <bunk@kernel.org>

Remove dead code reported by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/setup.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/xtensa/kernel/setup.c~xtensa-kernel-setupc-remove-dead-code arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~xtensa-kernel-setupc-remove-dead-code
+++ a/arch/xtensa/kernel/setup.c
@@ -60,11 +60,6 @@ struct ide_ops *ide_ops;
 extern struct rtc_ops no_rtc_ops;
 struct rtc_ops *rtc_ops;
 
-#ifdef CONFIG_PC_KEYB
-extern struct kbd_ops no_kbd_ops;
-struct kbd_ops *kbd_ops;
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 extern void *initrd_start;
 extern void *initrd_end;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
git-x86.patch
git-xtensa.patch
drivers-cpufreq-cpufreq_statsc-section-fix.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
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
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
