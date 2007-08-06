From: akpm@linux-foundation.org
Subject: + kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:53:16 -0700
Message-ID: <200708061953.l76JrGJ2011856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765045AbXHFTxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com


The patch titled
     kernel-parameters.txt : watchdog.txt should be wdt.txt
has been added to the -mm tree.  Its filename is
     kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-parameters.txt : watchdog.txt should be wdt.txt
From: Gabriel C <nix.or.die@googlemail.com>

Documentation/watchdog/watchdog.txt does not exist, it is Documentation/watchdog/wdt.txt

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~kernel-parameterstxt-watchdogtxt-should-be-wdttxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-parameterstxt-watchdogtxt-should-be-wdttxt
+++ a/Documentation/kernel-parameters.txt
@@ -1960,7 +1960,7 @@ and is between 256 and 4096 characters. 
 			See header of drivers/scsi/wd7000.c.
 
 	wdt=		[WDT] Watchdog
-			See Documentation/watchdog/watchdog.txt.
+			See Documentation/watchdog/wdt.txt.
 
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

linux-audit-list-is-subscribers-only.patch
kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch
git-kvm.patch
fix-libata-warnings-with-config_pm=n.patch
mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
