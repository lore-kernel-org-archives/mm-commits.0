From: akpm@linux-foundation.org
Subject: [merged] video-imxfb-make-local-symbols-static.patch removed from -mm tree
Date: Mon, 01 Jul 2013 12:25:52 -0700
Message-ID: <51d1d7c0.fZ5RlwxfwyAi2+CU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3GATZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 15:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] video-imxfb-make-local-symbols-static.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 12:25:52 -0700


The patch titled
     Subject: drivers/video/imxfb.c: make local symbols static
has been removed from the -mm tree.  Its filename was
     video-imxfb-make-local-symbols-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/imxfb.c: make local symbols static

These symbols are used only in this file.  Make them static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/imxfb.c~video-imxfb-make-local-symbols-static drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~video-imxfb-make-local-symbols-static
+++ a/drivers/video/imxfb.c
@@ -960,7 +960,7 @@ static int imxfb_remove(struct platform_
 	return 0;
 }
 
-void  imxfb_shutdown(struct platform_device * dev)
+static void imxfb_shutdown(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct imxfb_info *fbi = info->par;
@@ -999,7 +999,7 @@ static int imxfb_setup(void)
 	return 0;
 }
 
-int __init imxfb_init(void)
+static int __init imxfb_init(void)
 {
 	int ret = imxfb_setup();
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-m48t86c-remove-empty-function.patch
drivers-rtc-rtc-tilec-remove-empty-function.patch
drivers-rtc-rtc-nuc900c-remove-empty-function.patch
drivers-rtc-rtc-msm6242c-remove-empty-function.patch
drivers-rtc-rtc-max8998c-remove-empty-function.patch
drivers-rtc-rtc-max8925c-remove-empty-function.patch
drivers-rtc-rtc-ls1xc-remove-empty-function.patch
drivers-rtc-rtc-lp8788c-remove-empty-function.patch
drivers-rtc-rtc-ds1302c-remove-empty-function.patch
drivers-rtc-rtc-dm355evmc-remove-empty-function.patch
drivers-rtc-rtc-da9055c-remove-empty-function.patch
drivers-rtc-rtc-da9052c-remove-empty-function.patch
drivers-rtc-rtc-bq4802c-remove-empty-function.patch
drivers-rtc-rtc-au1xxxc-remove-empty-function.patch
drivers-rtc-rtc-ab3100c-remove-empty-function.patch
drivers-rtc-rtc-bq32kc-remove-empty-function.patch
drivers-rtc-rtc-ds1216c-remove-empty-function.patch
drivers-rtc-rtc-ds1286c-remove-empty-function.patch
drivers-rtc-rtc-ds1672c-remove-empty-function.patch
drivers-rtc-rtc-ds3234c-remove-empty-function.patch
drivers-rtc-rtc-ds1390c-remove-empty-function.patch
drivers-rtc-rtc-efic-remove-empty-function.patch
drivers-rtc-rtc-em3027c-remove-empty-function.patch
drivers-rtc-rtc-fm3130c-remove-empty-function.patch
drivers-rtc-rtc-isl12022c-remove-empty-function.patch
drivers-rtc-rtc-m41t93c-remove-empty-function.patch
drivers-rtc-rtc-m48t35c-remove-empty-function.patch
drivers-rtc-rtc-genericc-remove-empty-function.patch
drivers-rtc-rtc-m41t94c-remove-empty-function.patch
drivers-rtc-rtc-max6902c-remove-empty-function.patch
drivers-rtc-rtc-max6900c-remove-empty-function.patch
drivers-rtc-rtc-max8907c-remove-empty-function.patch
drivers-rtc-rtc-max77686c-remove-empty-function.patch
drivers-rtc-rtc-max8997c-remove-empty-function.patch
drivers-rtc-rtc-pcf8523c-remove-empty-function.patch
drivers-rtc-rtc-pcf8563c-remove-empty-function.patch
drivers-rtc-rtc-pcf8583c-remove-empty-function.patch
drivers-rtc-rtc-ps3c-remove-empty-function.patch
drivers-rtc-rtc-rs5c313c-remove-empty-function.patch
drivers-rtc-rtc-rv3029c2c-remove-empty-function.patch
drivers-rtc-rtc-rx4581c-remove-empty-function.patch
drivers-rtc-rtc-rs5c348c-remove-empty-function.patch
drivers-rtc-rtc-rx8581c-remove-empty-function.patch
drivers-rtc-rtc-snvsc-remove-empty-function.patch
drivers-rtc-rtc-starfirec-remove-empty-function.patch
drivers-rtc-rtc-sun4vc-remove-empty-function.patch
drivers-rtc-rtc-tps80031c-remove-empty-function.patch
drivers-rtc-rtc-wm831xc-remove-empty-function.patch
drivers-rtc-rtc-ds1302c-handle-write-protection.patch
drivers-rtc-rtc-da9052c-use-ptr_ret.patch
drivers-rtc-rtc-isl12022c-use-ptr_ret.patch
drivers-rtc-rtc-m48t35c-use-ptr_ret.patch
drivers-rtc-rtc-pcf8563c-use-ptr_ret.patch
drivers-rtc-rtc-pcf8583c-use-ptr_ret.patch

