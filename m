From: akpm@linux-foundation.org
Subject: + v4l-dvb-cimax2c-fix-typo.patch added to -mm tree
Date: Mon, 27 Apr 2009 12:10:29 -0700
Message-ID: <200904271910.n3RJATUb005546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066AbZD0TOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 15:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, aospan@netup.ru, liplianin@netup.ru, mchehab@infradead.org


The patch titled
     V4L/DVB: cimax2.c: fix &/&& typo
has been added to the -mm tree.  Its filename is
     v4l-dvb-cimax2c-fix-typo.patch

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
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

