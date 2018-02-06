From: akpm@linux-foundation.org
Subject: [patch 059/114] <asm-generic/siginfo.h>: fix language in
 comments
Date: Tue, 06 Feb 2018 15:39:27 -0800
Message-ID: <20180206233927.ZSGHHuh0O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXj2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
