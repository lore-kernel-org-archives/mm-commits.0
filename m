From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:28 -0700
Message-ID: <20130507223928.CC7C95A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36188 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3EGWj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:29 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so121057yho.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: remove space before tabs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-pcf2123.c: remove space before tabs

Silences the following checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-remove-space-before-tabs drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-remove-space-before-tabs
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -18,11 +18,11 @@
  * should look something like:
  *
  * static struct spi_board_info ek_spi_devices[] = {
- * 	...
- * 	{
- * 		.modalias		= "rtc-pcf2123",
- * 		.chip_select		= 1,
- * 		.controller_data	= (void *)AT91_PIN_PA10,
+ *	...
+ *	{
+ *		.modalias		= "rtc-pcf2123",
+ *		.chip_select		= 1,
+ *		.controller_data	= (void *)AT91_PIN_PA10,
  *		.max_speed_hz		= 1000 * 1000,
  *		.mode			= SPI_CS_HIGH,
  *		.bus_num		= 0,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
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
drivers-rtc-rtc-pxac-use-devm_-apis.patch

