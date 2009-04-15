From: akpm@linux-foundation.org
Subject: [merged] powerpc-allow-256kb-pages-with-shmem.patch removed from -mm tree
Date: Wed, 15 Apr 2009 12:37:50 -0700
Message-ID: <200904151937.n3FJboHv021937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbZDOTk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 15:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, paulus@samba.org, yur@emcraft.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: allow 256kB pages with SHMEM
has been removed from the -mm tree.  Its filename was
     powerpc-allow-256kb-pages-with-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: allow 256kB pages with SHMEM
From: Hugh Dickins <hugh@veritas.com>

Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
let powerpc 256kB pages coexist with CONFIG_SHMEM again.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Yuri Tikhonov <yur@emcraft.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~powerpc-allow-256kb-pages-with-shmem arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-allow-256kb-pages-with-shmem
+++ a/arch/powerpc/Kconfig
@@ -462,7 +462,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size" if 44x
-	depends on !STDBINUTILS && (!SHMEM || BROKEN)
+	depends on !STDBINUTILS
 	help
 	  Make the page size 256k.
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

