From: akpm@linux-foundation.org
Subject: [folded-merged]
 list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:53:46 -0700
Message-ID: <53e2b1fa.IvGLjAdE3XR5E2cm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:60273 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFWxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:53:47 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so438702ykb.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:53:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kenhelias@firemail.de, mm-commits@vger.kernel.org


The patch titled
     Subject: list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch

This patch was dropped because it was folded into list-fix-order-of-arguments-for-hlist_add_after_rcu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes

ERROR: code indent should use tabs where possible
#177: FILE: include/linux/rculist.h:453:
+^I^I^I^I        struct hlist_node *prev)$

total: 1 errors, 0 warnings, 0 checks, 151 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/list-fix-order-of-arguments-for-hlist_add_after_rcu.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ken Helias <kenhelias@firemail.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes include/linux/rculist.h
--- a/include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes
+++ a/include/linux/rculist.h
@@ -450,7 +450,7 @@ static inline void hlist_add_before_rcu(
  * problems on Alpha CPUs.
  */
 static inline void hlist_add_behind_rcu(struct hlist_node *n,
-				        struct hlist_node *prev)
+					struct hlist_node *prev)
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

