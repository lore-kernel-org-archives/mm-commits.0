From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-update-comments-for-generic-idle-conversion.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:41:56 -0700
Message-ID: <53960e04.3kCbyp+XBEqEai4K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaFITl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, benh@kernel.crashing.org, geert+renesas@glider.be

Subject: [merged] powerpc-update-comments-for-generic-idle-conversion.patch removed from -mm tree
To: geert+renesas@glider.be,benh@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:56 -0700


The patch titled
     Subject: powerpc: update comments for generic idle conversion
has been removed from the -mm tree.  Its filename was
     powerpc-update-comments-for-generic-idle-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

