From: akpm@linux-foundation.org
Subject: + radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch added to -mm tree
Date: Wed, 27 May 2009 23:55:11 -0700
Message-ID: <200905280655.n4S6tB6v022943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZE1Gzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, benh@kernel.crashing.org, krzysztof.h1@poczta.fm


The patch titled
     radeon: P2G2CLK_ALWAYS_ONb tested twice, should 2nd be P2G2CLK_DAC_ALWAYS_ONb?
has been added to the -mm tree.  Its filename is
     radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch

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
Subject: radeon: P2G2CLK_ALWAYS_ONb tested twice, should 2nd be P2G2CLK_DAC_ALWAYS_ONb?
From: Roel Kluin <roel.kluin@gmail.com>

P2G2CLK_ALWAYS_ONb is tested twice, 2nd should be P2G2CLK_DAC_ALWAYS_ONb.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_pm.c~radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb
+++ a/drivers/video/aty/radeon_pm.c
@@ -395,7 +395,7 @@ static void radeon_pm_enable_dynamic_mod
 			PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb      |
 			PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb        |
 			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb           |
-			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb);
+			PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb);
 		OUTPLL(pllPIXCLKS_CNTL, tmp);
 
 		tmp = INPLL(pllMCLK_MISC);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
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
wmm_paramac_aci_acm_aifsn-tested-twice.patch
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
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

