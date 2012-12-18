From: akpm@linux-foundation.org
Subject: [merged] drivers-remove-reference-to-feature-removal-scheduletxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:49 -0800
Message-ID: <20121218200250.22A73200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:64836 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:52 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so63222eek.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: remove reference to feature-removal-schedule.txt
has been removed from the -mm tree.  Its filename was
     drivers-remove-reference-to-feature-removal-scheduletxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: drivers: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/net/wireless/Kconfig~drivers-remove-reference-to-feature-removal-scheduletxt drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~drivers-remove-reference-to-feature-removal-scheduletxt
+++ a/drivers/net/wireless/Kconfig
@@ -156,11 +156,7 @@ config PRISM54
 	---help---
 	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
 	  driver is now deprecated in favor for the SoftMAC driver, p54pci.
-	  p54pci supports FullMAC PCI/Cardbus devices as well. For details on
-	  the scheduled removal of this driver on the kernel see the feature
-	  removal schedule:
