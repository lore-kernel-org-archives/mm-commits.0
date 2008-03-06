From: akpm@linux-foundation.org
Subject: - disable-kgdb-on-ppc.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:17 -0800
Message-ID: <200803062228.m26MSHrJ021170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679AbYCFWdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:33:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     disable kgdb on ppc
has been removed from the -mm tree.  Its filename was
     disable-kgdb-on-ppc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: disable kgdb on ppc
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kgdb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.kgdb~disable-kgdb-on-ppc lib/Kconfig.kgdb
--- a/lib/Kconfig.kgdb~disable-kgdb-on-ppc
+++ a/lib/Kconfig.kgdb
@@ -14,7 +14,7 @@ config KGDB
 	bool "KGDB: kernel debugging with remote gdb"
 	select WANT_EXTRA_DEBUG_INFORMATION
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

git-x86.patch
git-md-accel.patch
hugetlb-correct-page-count-for-surplus-huge-pages-fix.patch
slab-pass-correct-flags-to-kmem_getpages.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

