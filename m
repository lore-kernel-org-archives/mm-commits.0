From: akpm@linux-foundation.org
Subject: [merged] vesafb-bitwise-or-has-higher-precedence-than.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:55 -0700
Message-ID: <200904011843.n31IhtT2010225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759413AbZDATZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:25:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, michalj@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vesafb: bitwise OR has higher precedence than ?:
has been removed from the -mm tree.  Its filename was
     vesafb-bitwise-or-has-higher-precedence-than.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vesafb: bitwise OR has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Michal Januszewski <michalj@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vesafb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/vesafb.c~vesafb-bitwise-or-has-higher-precedence-than drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~vesafb-bitwise-or-has-higher-precedence-than
+++ a/drivers/video/vesafb.c
@@ -438,7 +438,7 @@ static int __init vesafb_probe(struct pl
 	info->var = vesafb_defined;
 	info->fix = vesafb_fix;
 	info->flags = FBINFO_FLAG_DEFAULT |
-		(ypan) ? FBINFO_HWACCEL_YPAN : 0;
+		(ypan ? FBINFO_HWACCEL_YPAN : 0);
 
 	if (!ypan)
 		info->fbops->fb_pan_display = NULL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

