From: akpm@linux-foundation.org
Subject: - x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:23 -0700
Message-ID: <200707192010.l6JKANph020665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761407AbXGSUQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, alan@redhat.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: Geode HW Random Number Generator depends on X86_32
has been removed from the -mm tree.  Its filename was
     x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: Geode HW Random Number Generator depends on X86_32
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hw_random/Kconfig~x86_64-geode-hw-random-number-generator-depend-on-x86_3 drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~x86_64-geode-hw-random-number-generator-depend-on-x86_3
+++ a/drivers/char/hw_random/Kconfig
@@ -41,7 +41,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
-	depends on HW_RANDOM && X86 && PCI
+	depends on HW_RANDOM && X86_32 && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
