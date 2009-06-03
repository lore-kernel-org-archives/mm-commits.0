From: akpm@linux-foundation.org
Subject: [merged] wmm_paramac_aci_acm_aifsn-tested-twice.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:21 -0700
Message-ID: <200906032002.n53K2LOt001689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbZFCUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, andreamrl@tiscali.it, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtl8187se/ieee80211/ieee80211_rx.c: wmm_param[1].ac_aci_acm_aifsn tested twice
has been removed from the -mm tree.  Its filename was
     wmm_paramac_aci_acm_aifsn-tested-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtl8187se/ieee80211/ieee80211_rx.c: wmm_param[1].ac_aci_acm_aifsn tested twice
From: Roel Kluin <roel.kluin@gmail.com>

wmm_param[1].ac_aci_acm_aifsn was tested twice, the second should have been
wmm_param[3].ac_aci_acm_aifsn.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrea Merello <andreamrl@tiscali.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~wmm_paramac_aci_acm_aifsn-tested-twice drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~wmm_paramac_aci_acm_aifsn-tested-twice
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1680,7 +1680,7 @@ inline void update_network(struct ieee80
 	if(src->wmm_param[0].ac_aci_acm_aifsn|| \
 	   src->wmm_param[1].ac_aci_acm_aifsn|| \
 	   src->wmm_param[2].ac_aci_acm_aifsn|| \
-	   src->wmm_param[1].ac_aci_acm_aifsn) {
+	   src->wmm_param[3].ac_aci_acm_aifsn) {
 	  memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 	}
 	dst->QoS_Enable = src->QoS_Enable;
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

