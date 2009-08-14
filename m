From: akpm@linux-foundation.org
Subject: [to-be-updated] spinlock-allow-inlined-spinlocks-on-s390.patch removed from -mm tree
Date: Fri, 14 Aug 2009 16:33:04 -0700
Message-ID: <200908142333.n7ENX4Bs025218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbZHNXdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 19:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     spinlock: allow inlined spinlocks on s390
has been removed from the -mm tree.  Its filename was
     spinlock-allow-inlined-spinlocks-on-s390.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spinlock: allow inlined spinlocks on s390
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/Kconfig~spinlock-allow-inlined-spinlocks-on-s390 arch/s390/Kconfig
--- a/arch/s390/Kconfig~spinlock-allow-inlined-spinlocks-on-s390
+++ a/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select HAVE_KRETPROBES
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_SPINLOCK_INLINE_SUPPORT
 	select INIT_ALL_POSSIBLE
 	select HAVE_PERF_COUNTERS
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
spinlock-move-spinlock-function-bodies-to-header-file.patch
spinlock-allow-inlined-spinlocks-on-s390.patch

