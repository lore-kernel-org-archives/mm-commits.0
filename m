From: akpm@linux-foundation.org
Subject: + drivers-remove-reference-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:14:51 -0800
Message-ID: <20121108201452.458D5100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40756 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2KHUOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:14:54 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so373628vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:14:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com


The patch titled
     Subject: drivers: remove reference to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     drivers-remove-reference-to-feature-removal-scheduletxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
