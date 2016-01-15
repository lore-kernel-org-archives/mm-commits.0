From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:49 -0800
Message-ID: <569973cd.WR3hfBYfqt6vEUwM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mina86@mina86.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: improve comment for compact_memory tunable knob handler
has been removed from the -mm tree.  Its filename was
     mm-compaction-improve-comment-for-compact_memory-tunable-knob-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/compaction: improve comment for compact_memory tunable knob handler

sysctl_compaction_handler() is the handler function for compact_memory
tunable knob under /proc/sys/vm, add the missing knob name to make this
more accurate in comment.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
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

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

