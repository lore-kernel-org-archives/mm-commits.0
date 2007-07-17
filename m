From: akpm@linux-foundation.org
Subject: + slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch added to -mm tree
Date: Tue, 17 Jul 2007 02:15:20 -0700
Message-ID: <200707170919.l6H9Jj0k009518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbXGQJUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 05:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff
has been added to the -mm tree.  Its filename is
     slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff
From: Andrew Morton <akpm@linux-foundation.org>

my life sucks

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff mm/slub.c
--- a/mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff
+++ a/mm/slub.c
@@ -3022,7 +3022,7 @@ static int list_locations(struct kmem_ca
 	int node;
 
 	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
-			GFP_KERNEL))
+			GFP_TEMPORARY))
 		return sprintf(buf, "Out of memory\n");
 
 	/* Push back cpu slabs */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-driver-for-ds1216-chips.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
