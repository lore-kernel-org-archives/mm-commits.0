From: akpm@linux-foundation.org
Subject: + gitignore-update.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:08:45 -0700
Message-ID: <200707262008.l6QK8jWm018509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765534AbXGZUKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     .gitignore update
has been added to the -mm tree.  Its filename is
     gitignore-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_powernow_k8_acpi-must-depend-on-acpi.patch
gitignore-update.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling.patch
use-list_head-in-binfmt-handling-fix.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
