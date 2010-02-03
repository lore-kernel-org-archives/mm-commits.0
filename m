From: akpm@linux-foundation.org
Subject: [merged] fault-injection-correct-function-names-in-documentation.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:14 -0800
Message-ID: <201002031755.o13HtEDA008966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932778Ab0BCRzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault injection: correct function names in documentation
has been removed from the -mm tree.  Its filename was
     fault-injection-correct-function-names-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor.patch
zlib-make-new-optimized-inflate-endian-independent.patch

