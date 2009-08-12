From: akpm@linux-foundation.org
Subject: + spinlock-allow-inlined-spinlocks-on-s390.patch added to -mm tree
Date: Wed, 12 Aug 2009 14:42:40 -0700
Message-ID: <200908122142.n7CLgeGA023495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbZHLVnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 17:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     spinlock: allow inlined spinlocks on s390
has been added to the -mm tree.  Its filename is
     spinlock-allow-inlined-spinlocks-on-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
spinlock-allow-inlined-spinlocks.patch
spinlock-allow-inlined-spinlocks-on-s390.patch

