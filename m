From: akpm@linux-foundation.org
Subject: + consolidate-config_debug_strict_user_copy_checks-fix.patch added to -mm tree
Date: Mon, 01 Aug 2011 15:05:02 -0700
Message-ID: <201108012205.p71M525l017317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1HAWFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 18:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sedat.dilek@googlemail.com, rdunlap@xenotime.net, sboyd@codeaurora.org, sedat.dilek@gmail.com


The patch titled
     consolidate-config_debug_strict_user_copy_checks-fix
has been added to the -mm tree.  Its filename is
     consolidate-config_debug_strict_user_copy_checks-fix.patch

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
Subject: consolidate-config_debug_strict_user_copy_checks-fix
From: Sedat Dilek <sedat.dilek@googlemail.com>

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
 	 is_single_threaded.o plist.o decompress.o find_next_bit.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from sedat.dilek@googlemail.com are

i915-add-native-backlight-control.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch

