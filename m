From: akpm@linux-foundation.org
Subject: [merged] wis-sony-tunerc-typo.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:15 -0700
Message-ID: <200906032002.n53K2FBn001588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbZFCUCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     wis-sony-tuner.c: fix &&/|| error
has been removed from the -mm tree.  Its filename was
     wis-sony-tunerc-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wis-sony-tuner.c: fix &&/|| error
From: Roel Kluin <roel.kluin@gmail.com>

Fix &&/|| typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/go7007/wis-sony-tuner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/go7007/wis-sony-tuner.c~wis-sony-tunerc-typo drivers/staging/go7007/wis-sony-tuner.c
--- a/drivers/staging/go7007/wis-sony-tuner.c~wis-sony-tunerc-typo
+++ a/drivers/staging/go7007/wis-sony-tuner.c
@@ -370,7 +370,7 @@ static int set_if(struct i2c_client *cli
 	i2c_transfer(client->adapter, &msg, 1);
 
 	/* Select MPX mode if not forced by the user */
-	if (force_mpx_mode >= 0 || force_mpx_mode < MPX_NUM_MODES)
+	if (force_mpx_mode >= 0 && force_mpx_mode < MPX_NUM_MODES)
 		t->mpxmode = force_mpx_mode;
 	else
 		t->mpxmode = default_mpx_mode;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

