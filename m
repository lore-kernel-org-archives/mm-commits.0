From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-siginfoh-fix-language-in-comments.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:05 -0800
Message-ID: <20180207195805.UkGV82Qz3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59848 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbeBGT6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: <asm-generic/siginfo.h>: fix language in comments
has been removed from the -mm tree.  Its filename was
     asm-generic-siginfoh-fix-language-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: <asm-generic/siginfo.h>: fix language in comments

Fix grammar and add an omitted word.

Link: http://lkml.kernel.org/r/1a5a021c-0207-f793-7f07-addca26772d5@infradead.org
Fixes: f9886bc50a8e ("signal: Document the strange si_codes used by ptrace event stops")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/siginfo.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/uapi/asm-generic/siginfo.h~asm-generic-siginfoh-fix-language-in-comments include/uapi/asm-generic/siginfo.h
--- a/include/uapi/asm-generic/siginfo.h~asm-generic-siginfoh-fix-language-in-comments
+++ a/include/uapi/asm-generic/siginfo.h
@@ -280,8 +280,8 @@ typedef struct siginfo {
 #define NSIGTRAP	4
 
 /*
- * There are an additional set of SIGTRAP si_codes used by ptrace
- * that of the form: ((PTRACE_EVENT_XXX << 8) | SIGTRAP)
+ * There is an additional set of SIGTRAP si_codes used by ptrace
+ * that are of the form: ((PTRACE_EVENT_XXX << 8) | SIGTRAP)
  */
 
 /*
_

Patches currently in -mm which might be from rdunlap@infradead.org are


