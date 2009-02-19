From: akpm@linux-foundation.org
Subject: [merged] b43-bitwise-or-has-higher-precedence-than.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:47 -0800
Message-ID: <200902191917.n1JJHlZV016412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbZBSTSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, Larry.Finger@lwfinger.net, linville@tuxdriver.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     b43: bitwise OR has higher precedence than ?:
has been removed from the -mm tree.  Its filename was
     b43-bitwise-or-has-higher-precedence-than.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b43: bitwise OR has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/lo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/b43/lo.c~b43-bitwise-or-has-higher-precedence-than drivers/net/wireless/b43/lo.c
--- a/drivers/net/wireless/b43/lo.c~b43-bitwise-or-has-higher-precedence-than
+++ a/drivers/net/wireless/b43/lo.c
@@ -783,7 +783,7 @@ struct b43_lo_calib * b43_calibrate_lo_s
 			  | rfatt->att);
 	b43_radio_write16(dev, txctl_reg,
 			  (b43_radio_read16(dev, txctl_reg) & ~txctl_value)
-			  | (rfatt->with_padmix) ? txctl_value : 0);
+			  | (rfatt->with_padmix ? txctl_value : 0));
 
 	max_rx_gain = rfatt->att * 2;
 	max_rx_gain += bbatt->att / 2;
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

