From: akpm@linux-foundation.org
Subject: - frv-remove-dead-config-symbol-from-frv-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:27 -0800
Message-ID: <200802052233.m15MX8SK012383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762517AbYBEWlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: remove dead config symbol from FRV code
has been removed from the -mm tree.  Its filename was
     frv-remove-dead-config-symbol-from-frv-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: remove dead config symbol from FRV code
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbol from FRV code.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/page.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/asm-frv/page.h~frv-remove-dead-config-symbol-from-frv-code include/asm-frv/page.h
--- a/include/asm-frv/page.h~frv-remove-dead-config-symbol-from-frv-code
+++ a/include/asm-frv/page.h
@@ -76,10 +76,6 @@ extern unsigned long max_pfn;
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
-#define WANT_PAGE_VIRTUAL	1
-#endif
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
