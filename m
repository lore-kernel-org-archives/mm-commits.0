From: akpm@osdl.org
Subject: - atomich-complete-atomic_long-operations-in-asm-generic-fix-2.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:18:35 -0800
Message-ID: <200701271019.l0RAJPhx007063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXA0KTh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     atomich-complete-atomic_long-operations-in-asm-generic fix 2
has been removed from the -mm tree.  Its filename was
     atomich-complete-atomic_long-operations-in-asm-generic-fix-2.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: atomich-complete-atomic_long-operations-in-asm-generic fix 2
=46rom: Peter Zijlstra <a.p.zijlstra@chello.nl>

ARCH=3Dum SUBARCH=3Di386

In file included from include2/asm/arch/atomic.h:257,
                 from include2/asm/atomic.h:10,
                 from /usr/src/linux-2.6-git/include/linux/file.h:9,
                 from /usr/src/linux-2.6-git/mm/fadvise.c:12:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function =E2=80=
=98atomic_long_add_unless=E2=80=99:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h:260: warning: impli=
cit declaration of function =E2=80=98cmpxchg=E2=80=99
/usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function =E2=80=
=98atomic_long_xchg=E2=80=99:
/usr/src/linux-2.6-git/include/asm-generic/atomic.h:281: warning: impli=
cit declaration of function =E2=80=98xchg=E2=80=99

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-um/atomic.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-um/atomic.h~atomich-complete-atomic_long-operatio=
ns-in-asm-generic-fix-2 include/asm-um/atomic.h
--- a/include/asm-um/atomic.h~atomich-complete-atomic_long-operations-i=
n-asm-generic-fix-2
+++ a/include/asm-um/atomic.h
@@ -6,6 +6,7 @@
  */
 #include "linux/kernel.h"
=20
+#include "asm/arch/system.h"
 #include "asm/arch/atomic.h"
=20
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
nfs-fix-congestion-control-v4.patch
nfs-fix-congestion-control-v4-tweaks.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix-2.patch
