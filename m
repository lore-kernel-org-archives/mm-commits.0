From: akpm@linux-foundation.org
Subject: + rtc-nuc900-fix-build-warning.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:42:32 -0700
Message-ID: <201006301942.o5UJgWlG022541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0F3TnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     rtc/nuc900: fix build warning
has been added to the -mm tree.  Its filename is
     rtc-nuc900-fix-build-warning.patch

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
Subject: rtc/nuc900: fix build warning
From: Wan ZongShun <mcuos.com@gmail.com>

Remove unused local variable.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-nuc900-fix-build-warning drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-nuc900-fix-build-warning
+++ a/drivers/rtc/rtc-nuc900.c
@@ -85,7 +85,7 @@ static irqreturn_t nuc900_rtc_interrupt(
 
 static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 {
-	unsigned int i, timeout = 0x1000;
+	unsigned int timeout = 0x1000;
 	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
 
 	mdelay(10);
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

rtc-fix-ds1388-time-corruption.patch
drivers-video-nuc900fbc-fix-lcd-build-error.patch
linux-next.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch
rtc-add-intersil-isl12022-rtc-driver.patch
rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch
rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-m48t86-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-nuc900-make-returning-time-checking-function-valid.patch
rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location.patch
rtc-nuc900-fix-build-warning.patch

