From: akpm@linux-foundation.org
Subject: [merged] backlight-lp8788-staticize-default_bl_config.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:42 -0800
Message-ID: <5283e3ca.MYaGzld9ChzQzb30%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3KMUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lp8788-staticize-default_bl_config.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:42 -0800


The patch titled
     Subject: backlight: lp8788: staticize 'default_bl_config'
has been removed from the -mm tree.  Its filename was
     backlight-lp8788-staticize-default_bl_config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lp8788: staticize 'default_bl_config'

Fix the following sparse warning:

drivers/video/backlight/lp8788_bl.c:55:25: warning: symbol 'default_bl_config' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp8788_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp8788_bl.c~backlight-lp8788-staticize-default_bl_config drivers/video/backlight/lp8788_bl.c
--- a/drivers/video/backlight/lp8788_bl.c~backlight-lp8788-staticize-default_bl_config
+++ a/drivers/video/backlight/lp8788_bl.c
@@ -52,7 +52,7 @@ struct lp8788_bl {
 	struct pwm_device *pwm;
 };
 
-struct lp8788_bl_config default_bl_config = {
+static struct lp8788_bl_config default_bl_config = {
 	.bl_mode    = LP8788_BL_REGISTER_ONLY,
 	.dim_mode   = LP8788_DIM_EXPONENTIAL,
 	.full_scale = LP8788_FULLSCALE_1900uA,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

