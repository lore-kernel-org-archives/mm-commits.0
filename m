From: akpm@linux-foundation.org
Subject: + module-remove-duplicate-declaration-of-__ksymtab_gpl_future.patch added to -mm tree
Date: Thu, 20 May 2010 14:32:46 -0700
Message-ID: <201005202132.o4KLWkNn006362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665Ab0ETVcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wenji.huang@oracle.com


The patch titled
     module: remove duplicate declaration of __ksymtab_gpl_future
has been added to the -mm tree.  Its filename is
     module-remove-duplicate-declaration-of-__ksymtab_gpl_future.patch

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
Subject: module: remove duplicate declaration of __ksymtab_gpl_future
From: Wenji Huang <wenji.huang@oracle.com>

Minor cleanup on duplicate __{start/stop}__ksymtab_gpl_future.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/module.c~module-remove-duplicate-declaration-of-__ksymtab_gpl_future kernel/module.c
--- a/kernel/module.c~module-remove-duplicate-declaration-of-__ksymtab_gpl_future
+++ a/kernel/module.c
@@ -180,8 +180,6 @@ extern const struct kernel_symbol __star
 extern const struct kernel_symbol __stop___ksymtab_gpl[];
 extern const struct kernel_symbol __start___ksymtab_gpl_future[];
 extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
-extern const struct kernel_symbol __start___ksymtab_gpl_future[];
-extern const struct kernel_symbol __stop___ksymtab_gpl_future[];
 extern const unsigned long __start___kcrctab[];
 extern const unsigned long __start___kcrctab_gpl[];
 extern const unsigned long __start___kcrctab_gpl_future[];
_

Patches currently in -mm which might be from wenji.huang@oracle.com are

module-remove-duplicate-declaration-of-__ksymtab_gpl_future.patch

