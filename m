From: akpm@linux-foundation.org
Subject: - documentation-i386-io-apictxt-fix-description.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:23 -0700
Message-ID: <200803212030.m2LKUN8S008979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760405AbYCUUbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@nick-andrew.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/i386/IO-APIC.txt: fix description
has been removed from the -mm tree.  Its filename was
     documentation-i386-io-apictxt-fix-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/i386/IO-APIC.txt: fix description
From: Nick Andrew <nick@nick-andrew.net>

The description of the interrupt routing doesn't match the (nice) diagram.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i386/IO-APIC.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/i386/IO-APIC.txt~documentation-i386-io-apictxt-fix-description Documentation/i386/IO-APIC.txt
--- a/Documentation/i386/IO-APIC.txt~documentation-i386-io-apictxt-fix-description
+++ a/Documentation/i386/IO-APIC.txt
@@ -70,7 +70,7 @@ Every PCI card emits a PCI IRQ, which ca
 
 These INTA-D PCI IRQs are always 'local to the card', their real meaning
 depends on which slot they are in. If you look at the daisy chaining diagram,
-a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ2 of
+a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ4 of
 the PCI chipset. Most cards issue INTA, this creates optimal distribution
 between the PIRQ lines. (distributing IRQ sources properly is not a
 necessity, PCI IRQs can be shared at will, but it's a good for performance
_

Patches currently in -mm which might be from nick@nick-andrew.net are

git-x86.patch
kconfig-cleanup-block-kconfig-help-descriptions.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch

