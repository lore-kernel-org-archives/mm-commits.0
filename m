From: akpm@linux-foundation.org
Subject: + a.patch added to -mm tree
Date: Wed, 06 Apr 2016 20:36:07 -0700
Message-ID: <5705d5a7.c8lkk5z3NV/nwaKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbcDGDgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2016 23:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     a.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/a.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/a.patch

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
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/open.c~a fs/open.c
--- a/fs/open.c~a
+++ a/fs/open.c
@@ -1147,3 +1147,4 @@ int nonseekable_open(struct inode *inode
 }
 
 EXPORT_SYMBOL(nonseekable_open);
+Wed Apr  6 20:34:45 PDT 2016
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
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix-fix-2.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
a.patch

