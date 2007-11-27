From: akpm@linux-foundation.org
Subject: - m68k-export-atari_keyb_init.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:01 -0800
Message-ID: <200711272033.lARKX1lN028946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755596AbXK0Ude (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: export atari_keyb_init
has been removed from the -mm tree.  Its filename was
     m68k-export-atari_keyb_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: export atari_keyb_init
From: Adrian Bunk <bunk@kernel.org>

ERROR: "atari_keyb_init" [drivers/input/mouse/atarimouse.ko] undefined!
ERROR: "atari_keyb_init" [drivers/input/keyboard/atakbd.ko] undefined!

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/atakeyb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/m68k/atari/atakeyb.c~m68k-export-atari_keyb_init arch/m68k/atari/atakeyb.c
--- a/arch/m68k/atari/atakeyb.c~m68k-export-atari_keyb_init
+++ a/arch/m68k/atari/atakeyb.c
@@ -565,7 +565,7 @@ void atari_kbd_leds(unsigned int leds)
 
 static int atari_keyb_done = 0;
 
-int __init atari_keyb_init(void)
+int atari_keyb_init(void)
 {
 	if (atari_keyb_done)
 		return 0;
@@ -631,6 +631,7 @@ int __init atari_keyb_init(void)
 	atari_keyb_done = 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(atari_keyb_init);
 
 int atari_kbd_translate(unsigned char keycode, unsigned char *keycodep, char raw_mode)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
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
git-x86.patch
git-xtensa.patch
xtensa-kernel-setupc-remove-dead-code.patch
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
