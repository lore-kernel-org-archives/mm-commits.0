From: akpm@linux-foundation.org
Subject: [folded] consolidate-config_debug_strict_user_copy_checks-fix.patch removed from -mm tree
Date: Mon, 09 Jan 2012 13:58:03 -0800
Message-ID: <20120109224015.70464200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62304 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2AIWkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 17:40:18 -0500
Received: by eekc1 with SMTP id c1so150708eek.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 14:40:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sedat.dilek@googlemail.com, rdunlap@xenotime.net, sboyd@codeaurora.org, sedat.dilek@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: consolidate-config_debug_strict_user_copy_checks-fix
has been removed from the -mm tree.  Its filename was
     consolidate-config_debug_strict_user_copy_checks-fix.patch

This patch was dropped because it was folded into consolidate-config_debug_strict_user_copy_checks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: consolidate-config_debug_strict_user_copy_checks-fix

s/lib-/obj-/ for usercopy.o

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Randy Dunlap <rdunlap@xenotime.net>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~consolidate-config_debug_strict_user_copy_checks-fix lib/Makefile
--- a/lib/Makefile~consolidate-config_debug_strict_user_copy_checks-fix
+++ a/lib/Makefile
@@ -14,7 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from sedat.dilek@googlemail.com are

consolidate-config_debug_strict_user_copy_checks.patch

