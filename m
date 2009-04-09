From: akpm@linux-foundation.org
Subject: [to-be-updated] kbuild-remove-generated-logo-files-fix.patch removed from -mm tree
Date: Thu, 09 Apr 2009 14:05:19 -0700
Message-ID: <200904092105.n39L5J6V025536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764414AbZDIVJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com, jsimmons@infradead.org, krzysztof.h1@poczta.fm, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild-remove-generated-logo-files-fix
has been removed from the -mm tree.  Its filename was
     kbuild-remove-generated-logo-files-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild-remove-generated-logo-files-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/logo/Makefile~kbuild-remove-generated-logo-files-fix drivers/video/logo/Makefile
--- a/drivers/video/logo/Makefile~kbuild-remove-generated-logo-files-fix
+++ a/drivers/video/logo/Makefile
@@ -37,7 +37,7 @@ extra-y += $(call logo-cfiles,_clut224,p
 # Gray 256
 extra-y += $(call logo-cfiles,_gray256,pgm)
 
-pnmtlogo := scripts/pnmtologo
+pnmtologo := scripts/pnmtologo
 
 # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
 quiet_cmd_logo = LOGO    $@
@@ -45,16 +45,16 @@ quiet_cmd_logo = LOGO    $@
 			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
 			-n $(notdir $(basename $<)) -o $@ $<
 
-$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtlogo) FORCE
+$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtlogo) FORCE
+$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtlogo) FORCE
+$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtlogo) FORCE
+$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
 # Files generated that shall be removed upon make clean
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
hfs-fix-memory-leak-when-unmounting-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
kbuild-remove-generated-logo-files-fix.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

