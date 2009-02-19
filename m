From: akpm@linux-foundation.org
Subject: [merged] paride-pgc-xs-confusion.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:38 -0800
Message-ID: <200902191917.n1JJHcC5016394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbZBSTRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, bzolnier@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     paride/pg.c: xs(): &&/|| confusion
has been removed from the -mm tree.  Its filename was
     paride-pgc-xs-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: paride/pg.c: xs(): &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

&&/|| confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/paride/pg.c~paride-pgc-xs-confusion drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~paride-pgc-xs-confusion
+++ a/drivers/block/paride/pg.c
@@ -422,7 +422,7 @@ static void xs(char *buf, char *targ, in
 
 	for (k = 0; k < len; k++) {
 		char c = *buf++;
-		if (c != ' ' || c != l)
+		if (c != ' ' && c != l)
 			l = *targ++ = c;
 	}
 	if (l == ' ')
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
atm-bitwise-or-has-higher-precedence-than.patch
atm-add-missing-parentheses.patch
drivers-net-tg3c-fix-confusion.patch
smsc-timeout-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

