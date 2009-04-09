From: akpm@linux-foundation.org
Subject: + radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:13:23 -0700
Message-ID: <200904092213.n39MDNuZ022242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbZDIWQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, michel@daenzer.net, rtdrury@earthlink.net


The patch titled
     radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes.patch

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
Subject: radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#34: FILE: drivers/video/aty/radeon_backlight.c:105:
+^I^Iif(rinfo->family != CHIP_FAMILY_RV350 $

ERROR: space required before the open parenthesis '('
#34: FILE: drivers/video/aty/radeon_backlight.c:105:
+		if(rinfo->family != CHIP_FAMILY_RV350 

total: 2 errors, 0 warnings, 11 lines checked

./patches/radeonfb-backlight-shutoff-flashes-momentarily.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Robert T. Drury" <rtdrury@earthlink.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Michel Daenzer <michel@daenzer.net>
Cc: Robert Drury <rtdrury@earthlink.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_backlight.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_backlight.c~radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes
+++ a/drivers/video/aty/radeon_backlight.c
@@ -102,7 +102,7 @@ static int radeon_bl_update_status(struc
 		if (rinfo->is_mobility || rinfo->is_IGP)
 			OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
 		lvds_gen_cntl &= ~(LVDS_BL_MOD_LEVEL_MASK);
-		if(rinfo->family != CHIP_FAMILY_RV350 
+		if (rinfo->family != CHIP_FAMILY_RV350
 			|| !machine_is_compatible("PowerBook5,3"))
 				lvds_gen_cntl &= ~LVDS_BL_MOD_EN;
 		lvds_gen_cntl |= (radeon_bl_get_level_brightness(pdata, 0) <<
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
radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes.patch
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

