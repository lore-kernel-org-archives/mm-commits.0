From: akpm@linux-foundation.org
Subject: [merged]
 llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:25 -0800
Message-ID: <52867f75.cJNbtqhZAW/EDV0w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KOUJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, akpm@linux-foundation.org

Subject: [merged] llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:25 -0800


The patch titled
     Subject: llists-move-llist_reverse_order-from-raid5-to-llistc-fix
has been removed from the -mm tree.  Its filename was
     llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: llists-move-llist_reverse_order-from-raid5-to-llistc-fix

fix comment typo, per Jan

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/llist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/llist.c~llists-move-llist_reverse_order-from-raid5-to-llistc-fix lib/llist.c
--- a/lib/llist.c~llists-move-llist_reverse_order-from-raid5-to-llistc-fix
+++ a/lib/llist.c
@@ -86,7 +86,7 @@ EXPORT_SYMBOL_GPL(llist_del_first);
  * llist_reverse_order - reverse order of a llist chain
  * @head:	first item of the list to be reversed
  *
- * Reverse the oder of a chain of llist entries and return the
+ * Reverse the order of a chain of llist entries and return the
  * new first entry.
  */
 struct llist_node *llist_reverse_order(struct llist_node *head)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

