From: akpm@linux-foundation.org
Subject: - adm8211-remove-commented-out-code.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:44 -0700
Message-ID: <200804102001.m3AK1ieL014999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbYDJUDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, flamingice@sourmilk.net, johannes@sipsolutions.net, linville@tuxdriver.com, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     adm8211: remove commented-out code
has been removed from the -mm tree.  Its filename was
     adm8211-remove-commented-out-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
git-x86.patch
pm-remove-destroy_suspended_device.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
git-hrt.patch
git-net.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

