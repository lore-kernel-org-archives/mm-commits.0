From: akpm@linux-foundation.org
Subject: + kernel-padata-hide-unused-functions-checkpatch-fixes.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 13:16:31 -0700
Message-ID: <571a869f.1lDG534NLk3ibb2n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcDVUQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-padata-hide-unused-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-padata-hide-unused-functions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-padata-hide-unused-functions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-padata-hide-unused-functions-checkpatch-fixes.patch

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
Subject: kernel-padata-hide-unused-functions-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:WxO)
#48: FILE: kernel/padata.c:689:
+		err =-EINVAL;
 		    ^

ERROR: space required before that '-' (ctx:OxV)
#48: FILE: kernel/padata.c:689:
+		err =-EINVAL;
 		     ^

total: 2 errors, 0 warnings, 86 lines checked

./patches/kernel-padata-hide-unused-functions.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/padata.c~kernel-padata-hide-unused-functions-checkpatch-fixes kernel/padata.c
--- a/kernel/padata.c~kernel-padata-hide-unused-functions-checkpatch-fixes
+++ a/kernel/padata.c
@@ -686,7 +686,7 @@ int padata_start(struct padata_instance
 	mutex_lock(&pinst->lock);
 
 	if (pinst->flags & PADATA_INVALID)
-		err =-EINVAL;
+		err = -EINVAL;
 
 	 __padata_start(pinst);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
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
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

