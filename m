From: akpm@linux-foundation.org
Subject: + x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:25:30 -0700
Message-ID: <200706271925.l5RJPUFE003991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbXF0T0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, alan@redhat.com, yinghai.lu@Sun.COM


The patch titled
     x86_64: Geode HW Random Number Generator depends on X86_32
has been added to the -mm tree.  Its filename is
     x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-assert-dtr-for-serial-console-devices.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
