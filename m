From: akpm@linux-foundation.org
Subject: - kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:10 -0700
Message-ID: <200708140503.l7E53AfO032033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764820AbXHNFDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     kernel-parameters.txt : watchdog.txt should be wdt.txt
has been removed from the -mm tree.  Its filename was
     kernel-parameterstxt-watchdogtxt-should-be-wdttxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-parameters.txt : watchdog.txt should be wdt.txt
From: Gabriel C <nix.or.die@googlemail.com>

Documentation/watchdog/watchdog.txt does not exist, it is Documentation/watchdog/wdt.txt

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~kernel-parameterstxt-watchdogtxt-should-be-wdttxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-parameterstxt-watchdogtxt-should-be-wdttxt
+++ a/Documentation/kernel-parameters.txt
@@ -1922,7 +1922,7 @@ and is between 256 and 4096 characters. 
 			See header of drivers/scsi/wd7000.c.
 
 	wdt=		[WDT] Watchdog
-			See Documentation/watchdog/watchdog.txt.
+			See Documentation/watchdog/wdt.txt.
 
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

git-kvm.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
