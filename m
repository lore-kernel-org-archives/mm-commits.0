From: akpm@linux-foundation.org
Subject: + documentation-i386-io-apictxt-fix-description.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:09:15 -0800
Message-ID: <200802142109.m1EL9FEa002986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYBNVKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick@nick-andrew.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Documentation/i386/IO-APIC.txt: fix description
has been added to the -mm tree.  Its filename is
     documentation-i386-io-apictxt-fix-description.patch

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
@@ -68,7 +68,7 @@ every PCI card emits a PCI IRQ, which ca
 
 These INTA-D PCI IRQs are always 'local to the card', their real meaning
 depends on which slot they are in. If you look at the daisy chaining diagram,
-a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ2 of
+a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ4 of
 the PCI chipset. Most cards issue INTA, this creates optimal distribution
 between the PIRQ lines. (distributing IRQ sources properly is not a
 necessity, PCI IRQs can be shared at will, but it's a good for performance
_

Patches currently in -mm which might be from nick@nick-andrew.net are

documentation-i386-io-apictxt-fix-description.patch
