From: akpm@linux-foundation.org
Subject: +
 mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch added to -mm tree
Date: Wed, 25 Nov 2015 14:07:08 -0800
Message-ID: <5656310c.WeFbbl/CQxERbxKK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbKYWHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Nov 2015 17:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: improve comment for compact_memory tunable knob handler
has been added to the -mm tree.  Its filename is
     mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/compaction: improve comment for compact_memory tunable knob handler

sysctl_compaction_handler() is the handler function for compact_memory
tunable knob under /proc/sys/vm, add the missing knob name to make this
more accurate in comment.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler mm/compaction.c
--- a/mm/compaction.c~mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler
+++ a/mm/compaction.c
@@ -1708,7 +1708,10 @@ static void compact_nodes(void)
 /* The written value is actually unused, all memory is compacted */
 int sysctl_compact_memory;
 
-/* This is the entry point for compacting all nodes via /proc/sys/vm */
+/*
+ * This is the entry point for compacting all nodes via
+ * /proc/sys/vm/compact_memory
+ */
 int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos)
 {
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-hugetlb-is_file_hugepages-can-be-boolean.patch
mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
mm-lru-remove-unused-is_unevictable_lru-function.patch
mm-zonelist-enumerate-zonelists-array-index.patch
mm-mmzone-memmap_valid_within-can-be-boolean.patch
mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch
fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

