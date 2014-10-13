From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-deprecated-irqf_disabled.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:21 -0700
Message-ID: <543c1731.+x9RYxzL6mrH7tGx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaJMSRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: remove deprecated IRQF_DISABLED
has been removed from the -mm tree.  Its filename was
     m32r-remove-deprecated-irqf_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: m32r: remove deprecated IRQF_DISABLED

This patch removes the use of the IRQF_DISABLED flag
from arch/m32r/kernel/time.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/time.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m32r/kernel/time.c~m32r-remove-deprecated-irqf_disabled arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~m32r-remove-deprecated-irqf_disabled
+++ a/arch/m32r/kernel/time.c
@@ -134,7 +134,6 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "MFT2",
 };
 
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

origin.patch
maintainers-orphan-m32r.patch
maintainers-remove-chirag-kantharia-invalid-e-mail.patch
linux-next.patch

