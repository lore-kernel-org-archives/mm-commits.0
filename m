From: akpm@linux-foundation.org
Subject: + wis-sony-tunerc-typo.patch added to -mm tree
Date: Mon, 04 May 2009 15:59:14 -0700
Message-ID: <200905042259.n44MxEBQ028291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZEDXAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com


The patch titled
     wis-sony-tuner.c: &&/|| typo?
has been added to the -mm tree.  Its filename is
     wis-sony-tunerc-typo.patch

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
Subject: wis-sony-tuner.c: &&/|| typo?
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

origin.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
wis-sony-tunerc-typo.patch

