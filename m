From: akpm@linux-foundation.org
Subject: + mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch added to -mm tree
Date: Thu, 21 Apr 2016 15:50:12 -0700
Message-ID: <57195924.6lZuj5zciNnGNsrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbcDUWuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-abstract-compaction-feedback-to-helpers-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch

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
Subject: mm-compaction-abstract-compaction-feedback-to-helpers-fix

fix typo in comment, per Hillf

Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers-fix
+++ a/include/linux/compaction.h
@@ -95,7 +95,7 @@ static inline bool compaction_made_progr
 /* Compaction has failed and it doesn't make much sense to keep retrying. */
 static inline bool compaction_failed(enum compact_result result)
 {
-	/* All zones where scanned completely and still not result. */
+	/* All zones were scanned completely and still not result. */
 	if (result == COMPACT_COMPLETE)
 		return true;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

