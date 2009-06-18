From: akpm@linux-foundation.org
Subject: [merged] maintainers-fbdev-is-orphaned.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:49 -0700
Message-ID: <200906182243.n5IMhnDi002901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758720AbZFRWol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, joe@perches.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fbdev is orphaned
has been removed from the -mm tree.  Its filename was
     maintainers-fbdev-is-orphaned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fbdev is orphaned
From: Andrew Morton <akpm@linux-foundation.org>

Tony hasn't been heard from in 18 months and people keep sending him
things.

Cc: Joe Perches <joe@perches.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-fbdev-is-orphaned MAINTAINERS
--- a/MAINTAINERS~maintainers-fbdev-is-orphaned
+++ a/MAINTAINERS
@@ -2274,11 +2274,9 @@ F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
-P:	Antonino Daplas
-M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://linux-fbdev.sourceforge.net/
-S:	Maintained
+S:	Orphan
 F:	Documentation/fb/
 F:	drivers/video/fb*
 F:	include/linux/fb.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
char-moxa-prevent-opening-unavailable-ports.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

