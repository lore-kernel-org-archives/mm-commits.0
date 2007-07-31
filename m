From: akpm@linux-foundation.org
Subject: - gitignore-update.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:34 -0700
Message-ID: <200707312354.l6VNsYvJ029152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756918AbXGaXzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     .gitignore update
has been removed from the -mm tree.  Its filename was
     gitignore-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: .gitignore update
From: Alexey Dobriyan <adobriyan@sw.ru>

Somehow I ended up with the following in tree:

	$ git status
		...
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#       fs/proc/root.o.FuMxJQ
	#       net/ipv4/tcp_minisocks.o.geCDYR

These are presumably temporary gcc files, which aren't interesting.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-update .gitignore
--- a/.gitignore~gitignore-update
+++ a/.gitignore
@@ -7,6 +7,7 @@
 #
 .*
 *.o
+*.o.*
 *.a
 *.s
 *.ko
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-leak-on-proc-lockdep_stats.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
single_open-seq_release-leak-diagnostics.patch
