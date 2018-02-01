From: akpm@linux-foundation.org
Subject: + asm-generic-siginfoh-fix-language-in-comments.patch added to
 -mm tree
Date: Thu, 01 Feb 2018 14:41:09 -0800
Message-ID: <5a739785.SaOStiwBzmYCIr1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbeBAWlK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:41:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: <asm-generic/siginfo.h>: fix language in comments
has been added to the -mm tree.  Its filename is
     asm-generic-siginfoh-fix-language-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-siginfoh-fix-language-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-siginfoh-fix-language-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

asm-generic-siginfoh-fix-language-in-comments.patch

