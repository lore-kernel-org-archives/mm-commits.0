From: akpm@linux-foundation.org
Subject: + kernel-forkc-fix-coding-style-issues.patch added to -mm tree
Date: Mon, 02 Dec 2013 14:08:19 -0800
Message-ID: <529d04d3.UU5lopqbQLHLolqS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3LBWIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 17:08:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daeseok.youn@gmail.com

Subject: + kernel-forkc-fix-coding-style-issues.patch added to -mm tree
To: daeseok.youn@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 14:08:19 -0800


The patch titled
     Subject: kernel/fork.c: fix coding style issues
has been added to the -mm tree.  Its filename is
     kernel-forkc-fix-coding-style-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-forkc-fix-coding-style-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-forkc-fix-coding-style-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: kernel/fork.c: fix coding style issues

Fix errors reported by checkpatch.pl.  One error is parentheses, the other
is a whitespace issue.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-fix-coding-style-issues kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-fix-coding-style-issues
+++ a/kernel/fork.c
@@ -1644,7 +1644,7 @@ SYSCALL_DEFINE0(fork)
 	return do_fork(SIGCHLD, 0, 0, NULL, NULL);
 #else
 	/* can not support in nommu mode */
-	return(-EINVAL);
+	return -EINVAL;
 #endif
 }
 #endif
@@ -1652,7 +1652,7 @@ SYSCALL_DEFINE0(fork)
 #ifdef __ARCH_WANT_SYS_VFORK
 SYSCALL_DEFINE0(vfork)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0, 
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
 			0, NULL, NULL);
 }
 #endif
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

kernel-forkc-make-dup_mm-static.patch
kernel-forkc-fix-coding-style-issues.patch
kernel-forkc-remove-redundant-null-check-in-dup_mm.patch

