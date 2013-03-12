From: akpm@linux-foundation.org
Subject: + coredump-remove-trailling-whitespaces.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:38 -0700
Message-ID: <20130312203238.D65C95A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:35633 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:40 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so32244ghb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: coredump: remove trailling whitespace
has been added to the -mm tree.  Its filename is
     coredump-remove-trailling-whitespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

