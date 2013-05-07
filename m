From: akpm@linux-foundation.org
Subject: [merged] coredump-remove-trailling-whitespaces.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:15 -0700
Message-ID: <20130507174915.84B5131C2D0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42513 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:17 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so85323vbe.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: remove trailling whitespace
has been removed from the -mm tree.  Its filename was
     coredump-remove-trailling-whitespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: coredump: remove trailling whitespace

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/coredump.c~coredump-remove-trailling-whitespaces fs/coredump.c
--- a/fs/coredump.c~coredump-remove-trailling-whitespaces
+++ a/fs/coredump.c
@@ -522,7 +522,7 @@ void do_coredump(siginfo_t *siginfo)
 
 	ispipe = format_corename(&cn, &cprm);
 
- 	if (ispipe) {
+	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
 
@@ -576,10 +576,10 @@ void do_coredump(siginfo_t *siginfo)
 					NULL, &cprm);
 		argv_free(helper_argv);
 		if (retval) {
- 			printk(KERN_INFO "Core dump to %s pipe failed\n",
+			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       cn.corename);
 			goto close_fail;
- 		}
+		}
 	} else {
 		struct inode *inode;
 
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

origin.patch

