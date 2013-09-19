From: akpm@linux-foundation.org
Subject: +
 drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch added to -mm tree
Date: Thu, 19 Sep 2013 15:45:57 -0700
Message-ID: <523b7ea5.RJIrXzqTBlw7pVvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ISWp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, jg1.han@samsung.com

Subject: + drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch added to -mm tree
To: jg1.han@samsung.com,greg@kroah.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:45:57 -0700


The patch titled
     Subject: drivers/char/xilinx_hwicap/xilinx_hwicap.c: remove unneeded cast of void*
has been added to the -mm tree.  Its filename is
     drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/char/xilinx_hwicap/xilinx_hwicap.c: remove unneeded cast of void*

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.c~drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c~drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -721,7 +721,7 @@ static int hwicap_remove(struct device *
 {
 	struct hwicap_drvdata *drvdata;
 
-	drvdata = (struct hwicap_drvdata *)dev_get_drvdata(dev);
+	drvdata = dev_get_drvdata(dev);
 
 	if (!drvdata)
 		return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

