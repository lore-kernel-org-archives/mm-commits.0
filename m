From: akpm@linux-foundation.org
Subject: [merged] v4l-dvb-cimax2c-fix-typo.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:39 -0700
Message-ID: <200905272055.n4RKtdMM025927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759747AbZE0U42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, aospan@netup.ru, liplianin@netup.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     V4L/DVB: cimax2.c: fix &/&& typo
has been removed from the -mm tree.  Its filename was
     v4l-dvb-cimax2c-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: V4L/DVB: cimax2.c: fix &/&& typo
From: Roel Kluin <roel.kluin@gmail.com>

binary/logical and typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Abylay Ospan <aospan@netup.ru>
Cc: Igor M. Liplianin <liplianin@netup.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cimax2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx23885/cimax2.c~v4l-dvb-cimax2c-fix-typo drivers/media/video/cx23885/cimax2.c
--- a/drivers/media/video/cx23885/cimax2.c~v4l-dvb-cimax2c-fix-typo
+++ a/drivers/media/video/cx23885/cimax2.c
@@ -312,7 +312,7 @@ static void netup_read_ci_status(struct 
 		"TS config = %02x\n", __func__, state->ci_i2c_addr, 0, buf[0],
 		buf[32]);
 
-	if (buf[0] && 1)
+	if (buf[0] & 1)
 		state->status = DVB_CA_EN50221_POLL_CAM_PRESENT |
 			DVB_CA_EN50221_POLL_CAM_READY;
 	else
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

