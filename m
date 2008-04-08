From: akpm@linux-foundation.org
Subject: + adm8211-remove-commented-out-code.patch added to -mm tree
Date: Tue, 08 Apr 2008 01:03:58 -0700
Message-ID: <200804080803.m3883wO3015463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbYDHIFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 04:05:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, flamingice@sourmilk.net, johannes@sipsolutions.net, linville@tuxdriver.com, pavel@suse.cz


The patch titled
     adm8211: remove commented-out code
has been added to the -mm tree.  Its filename is
     adm8211-remove-commented-out-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adm8211: remove commented-out code
From: Pavel Machek <pavel@ucw.cz>

Remove some commented-out code from adm8211.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/adm8211.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/net/wireless/adm8211.c~adm8211-remove-commented-out-code drivers/net/wireless/adm8211.c
--- a/drivers/net/wireless/adm8211.c~adm8211-remove-commented-out-code
+++ a/drivers/net/wireless/adm8211.c
@@ -488,9 +488,6 @@ do {									   \
 	if (stsr & ADM8211_STSR_TCI)
 		adm8211_interrupt_tci(dev);
 
-	/*ADM8211_INT(LinkOn);*/
-	/*ADM8211_INT(LinkOff);*/
-
 	ADM8211_INT(PCF);
 	ADM8211_INT(BCNTC);
 	ADM8211_INT(GPINT);
@@ -500,7 +497,6 @@ do {									   \
 	ADM8211_INT(SQL);
 	ADM8211_INT(WEPTD);
 	ADM8211_INT(ATIME);
-	/*ADM8211_INT(TBTT);*/
 	ADM8211_INT(TEIS);
 	ADM8211_INT(FBE);
 	ADM8211_INT(REIS);
@@ -508,9 +504,6 @@ do {									   \
 	ADM8211_INT(RPS);
 	ADM8211_INT(RDU);
 	ADM8211_INT(TUF);
-	/*ADM8211_INT(TRT);*/
-	/*ADM8211_INT(TLT);*/
-	/*ADM8211_INT(TDU);*/
 	ADM8211_INT(TPS);
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-x86.patch
git-acpi.patch
pm-remove-destroy_suspended_device.patch
git-hrt.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
adm8211-remove-commented-out-code.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

