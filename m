From: akpm@linux-foundation.org
Subject: + fault-injection-correct-function-names-in-documentation.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:56:55 -0800
Message-ID: <201002012056.o11KutBP011952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab0BAU46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, akinobu.mita@gmail.com


The patch titled
     fault injection: correct function names in documentation
has been added to the -mm tree.  Its filename is
     fault-injection-correct-function-names-in-documentation.patch

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
Subject: fault injection: correct function names in documentation
From: Anton Blanchard <anton@samba.org>

init_fault_attr_entries() should be init_fault_attr_dentries().

cleanup_fault_attr_entries() should be cleanup_fault_attr_dentries().

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-correct-function-names-in-documentation Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-correct-function-names-in-documentation
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -143,8 +143,8 @@ o provide a way to configure fault attri
   failslab, fail_page_alloc, and fail_make_request use this way.
   Helper functions:
 
-	init_fault_attr_entries(entries, attr, name);
-	void cleanup_fault_attr_entries(entries);
+	init_fault_attr_dentries(entries, attr, name);
+	void cleanup_fault_attr_dentries(entries);
 
 - module parameters
 
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
fault-injection-correct-function-names-in-documentation.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
zlib-make-new-optimized-inflate-endian-independent.patch

