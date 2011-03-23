From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-remove-changelog-from-function-comment.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:14 -0700
Message-ID: <201103232040.p2NKeoR8028564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933386Ab1CWUla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: remove changelog from function comment
has been removed from the -mm tree.  Its filename was
     sys_swapon-remove-changelog-from-function-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove changelog from function comment
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Changelogs belong in the git history instead of in the source code.

Also, "The swapon system call" is redundant with
"SYSCALL_DEFINE2(swapon, ...)".

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-changelog-from-function-comment mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-changelog-from-function-comment
+++ a/mm/swapfile.c
@@ -1844,11 +1844,6 @@ static int __init max_swapfiles_check(vo
 late_initcall(max_swapfiles_check);
 #endif
 
-/*
- * Written 01/25/92 by Simmule Turner, heavily changed by Linus.
- *
- * The swapon system call
- */
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

