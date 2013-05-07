From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch added to -mm tree
Date: Tue, 07 May 2013 15:38:58 -0700
Message-ID: <20130507223858.D66DC5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:49617 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3EGWi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:38:59 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so121031yen.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:38:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix whitespace related errors
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch

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
Subject: drivers/rtc/rtc-cmos.c: fix whitespace related errors

Fixes the following types of issues:

ERROR: space required after that ',' (ctx:VxV)
WARNING: please, no spaces at the start of a line

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-whitespace-related-errors drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-whitespace-related-errors
+++ a/drivers/rtc/rtc-cmos.c
@@ -326,7 +326,7 @@ static void cmos_irq_disable(struct cmos
 static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-       unsigned char   mon, mday, hrs, min, sec, rtc_control;
+	unsigned char mon, mday, hrs, min, sec, rtc_control;
 
 	if (!is_valid_irq(cmos->irq))
 		return -EIO;
@@ -691,7 +691,7 @@ cmos_do_probe(struct device *dev, struct
 	/* FIXME:
 	 * <asm-generic/rtc.h> doesn't know 12-hour mode either.
 	 */
-       if (is_valid_irq(rtc_irq) && !(rtc_control & RTC_24H)) {
+	if (is_valid_irq(rtc_irq) && !(rtc_control & RTC_24H)) {
 		dev_warn(dev, "only 24-hr supported\n");
 		retval = -ENXIO;
 		goto cleanup1;
@@ -989,7 +989,7 @@ static int cmos_pnp_probe(struct pnp_dev
 {
 	cmos_wake_setup(&pnp->dev);
 
-	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
+	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0))
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
 		 * hardcode it in these cases
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

