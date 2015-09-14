From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-srcu-ify-shrinkers-fix.patch removed from -mm
 tree
Date: Mon, 14 Sep 2015 10:45:44 -0700
Message-ID: <55f707c8.z/i7e7OfKAy0EY3F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbINRpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-srcu-ify-shrinkers-fix
has been removed from the -mm tree.  Its filename was
     mm-srcu-ify-shrinkers-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm-srcu-ify-shrinkers-fix

temp

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix
+++ a/arch/powerpc/Kconfig
@@ -127,6 +127,7 @@ config PPC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select IRQ_FORCED_THREADING
+	select SRCU
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_BPF_JIT
_

Patches currently in -mm which might be from dave@stgolabs.net are


