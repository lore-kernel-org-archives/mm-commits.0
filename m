From: akpm@linux-foundation.org
Subject: + kprobes-another-maintainers-update.patch added to -mm tree
Date: Thu, 27 Mar 2008 12:36:07 -0700
Message-ID: <200803271936.m2RJa7JP018710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663AbYC0TgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 15:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com


The patch titled
     kprobes: another MAINTAINERS update
has been added to the -mm tree.  Its filename is
     kprobes-another-maintainers-update.patch

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
Subject: kprobes: another MAINTAINERS update
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Prasanna has taken a new job. Update the MAINTAINERS file

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~kprobes-another-maintainers-update MAINTAINERS
--- a/MAINTAINERS~kprobes-another-maintainers-update
+++ a/MAINTAINERS
@@ -2323,8 +2323,6 @@ L:	kexec@lists.infradead.org
 S:	Maintained
 
 KPROBES
-P:	Prasanna S Panchamukhi
-M:	prasanna@in.ibm.com
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
 P:	Anil S Keshavamurthy
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch
kprobes-another-maintainers-update.patch

