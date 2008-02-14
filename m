From: akpm@linux-foundation.org
Subject: + kernel-doc-remove-fastcall.patch added to -mm tree
Date: Thu, 14 Feb 2008 11:45:59 -0800
Message-ID: <200802141946.m1EJk1UH032050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762335AbYBNTqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 14:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, randy.dunlap@oracle.com


The patch titled
     kernel-doc: remove fastcall
has been added to the -mm tree.  Its filename is
     kernel-doc-remove-fastcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

fastcall is gone from the tree, no need to adjust the function prototypes
anymore for this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-remove-fastcall scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-remove-fastcall
+++ a/scripts/kernel-doc
@@ -1624,7 +1624,6 @@ sub dump_function($$) {
 
     $prototype =~ s/^static +//;
     $prototype =~ s/^extern +//;
-    $prototype =~ s/^fastcall +//;
     $prototype =~ s/^asmlinkage +//;
     $prototype =~ s/^inline +//;
     $prototype =~ s/^__inline__ +//;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
