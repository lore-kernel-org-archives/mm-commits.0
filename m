From: akpm@linux-foundation.org
Subject: + mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
 added to -mm tree
Date: Fri, 07 Feb 2014 12:52:45 -0800
Message-ID: <52f5479d.66OOA8LLkfL/fi/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaBGUwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 15:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, hughd@google.com, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,hughd@google.com,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 12:52:45 -0800


The patch titled
     Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix
has been added to the -mm tree.  Its filename is
     mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix

export the right function

Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/list_lru.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix mm/list_lru.c
--- a/mm/list_lru.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix
+++ a/mm/list_lru.c
@@ -143,7 +143,7 @@ int list_lru_init_key(struct list_lru *l
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(list_lru_init);
+EXPORT_SYMBOL_GPL(list_lru_init_key);
 
 void list_lru_destroy(struct list_lru *lru)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

