From: akpm@linux-foundation.org
Subject: [merged] leds-fix-confusion.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:14:01 -0800
Message-ID: <200902181014.n1IAE1Qt006142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbZBRKON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rdreier@cisco.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: fix &&/|| confusion
has been removed from the -mm tree.  Its filename was
     leds-fix-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9532.c~leds-fix-confusion drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-fix-confusion
+++ a/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_de
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND || (code != SND_BELL && code != SND_TONE))
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
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
ufs-sector_t-cannot-be-negative.patch

