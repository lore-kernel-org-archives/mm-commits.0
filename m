From: akpm@linux-foundation.org
Subject: + kprobes-maintainers-update.patch added to -mm tree
Date: Wed, 26 Mar 2008 12:59:28 -0700
Message-ID: <200803261959.m2QJxSQG031835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648AbYCZUAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 16:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com


The patch titled
     kprobes: MAINTAINERS update
has been added to the -mm tree.  Its filename is
     kprobes-maintainers-update.patch

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
Subject: kprobes: MAINTAINERS update
From: Masami Hiramatsu <mhiramat@redhat.com>

Add Masami Hiramatsu to kprobes maintainers

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~kprobes-maintainers-update MAINTAINERS
--- a/MAINTAINERS~kprobes-maintainers-update
+++ a/MAINTAINERS
@@ -2328,6 +2328,8 @@ P:	Anil S Keshavamurthy
 M:	anil.s.keshavamurthy@intel.com
 P:	David S. Miller
 M:	davem@davemloft.net
+P:	Masami Hiramatsu
+M:	mhiramat@redhat.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-maintainers-update.patch
kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

