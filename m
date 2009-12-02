From: akpm@linux-foundation.org
Subject: + ipc-remove-unreachable-code-in-semc.patch added to -mm tree
Date: Wed, 02 Dec 2009 14:45:59 -0800
Message-ID: <200912022245.nB2Mjxuf000686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbZLBWqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 17:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com


The patch titled
     ipc: remove unreachable code in sem.c
has been added to the -mm tree.  Its filename is
     ipc-remove-unreachable-code-in-semc.patch

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
Subject: ipc: remove unreachable code in sem.c
From: Amerigo Wang <amwang@redhat.com>

This line is unreachable, remove it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN ipc/sem.c~ipc-remove-unreachable-code-in-semc ipc/sem.c
--- a/ipc/sem.c~ipc-remove-unreachable-code-in-semc
+++ a/ipc/sem.c
@@ -701,7 +701,6 @@ static int semctl_nolock(struct ipc_name
 	default:
 		return -EINVAL;
 	}
-	return err;
 out_unlock:
 	sem_unlock(sma);
 	return err;
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
xtensa-use-generic-sys_pipe.patch
sysctl_max_map_count-should-be-non-negative.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

