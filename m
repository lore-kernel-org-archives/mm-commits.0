From: akpm@linux-foundation.org
Subject: [merged] ieee80211-add-missing-parentheses.patch removed from -mm tree
Date: Wed, 06 Jan 2010 13:33:50 -0800
Message-ID: <201001062133.o06LXoLs019146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932863Ab0AFVd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 16:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     ieee80211: add missing parentheses
has been removed from the -mm tree.  Its filename was
     ieee80211-add-missing-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ieee80211: add missing parentheses
From: Roel Kluin <roel.kluin@gmail.com>

not(!) has a higher precedence than bit and(&).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c~ieee80211-add-missing-parentheses drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c~ieee80211-add-missing-parentheses
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -718,7 +718,7 @@ int ieee80211_wx_get_encode_ext(struct i
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

