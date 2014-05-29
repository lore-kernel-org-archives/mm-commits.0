From: akpm@linux-foundation.org
Subject: + powerpc-update-comments-for-generic-idle-conversion.patch added to -mm tree
Date: Thu, 29 May 2014 16:00:38 -0700
Message-ID: <5387bc16.9NiPd5SAeh89Ih0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaE2XAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 19:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, benh@kernel.crashing.org, geert+renesas@glider.be

Subject: + powerpc-update-comments-for-generic-idle-conversion.patch added to -mm tree
To: geert+renesas@glider.be,benh@kernel.crashing.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 16:00:38 -0700


The patch titled
     Subject: powerpc: update comments for generic idle conversion
has been added to the -mm tree.  Its filename is
     powerpc-update-comments-for-generic-idle-conversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-update-comments-for-generic-idle-conversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-update-comments-for-generic-idle-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: powerpc: update comments for generic idle conversion

As of 799fef06123f ("powerpc: Use generic idle loop"), this applies to
arch_cpu_idle() instead of cpu_idle().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/irq.c~powerpc-update-comments-for-generic-idle-conversion arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~powerpc-update-comments-for-generic-idle-conversion
+++ a/arch/powerpc/kernel/irq.c
@@ -304,7 +304,7 @@ void notrace restore_interrupts(void)
  * being re-enabled and generally sanitized the lazy irq state,
  * and in the latter case it will leave with interrupts hard
  * disabled and marked as such, so the local_irq_enable() call
- * in cpu_idle() will properly re-enable everything.
+ * in arch_cpu_idle() will properly re-enable everything.
  */
 bool prep_irq_for_idle(void)
 {
_

Patches currently in -mm which might be from geert+renesas@glider.be are

linux-next.patch
idle-remove-cpu_idle-forward-declarations.patch
cris-update-comments-for-generic-idle-conversion.patch
powerpc-update-comments-for-generic-idle-conversion.patch

