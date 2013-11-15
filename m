From: akpm@linux-foundation.org
Subject: [merged]
 drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch removed from -mm tree
Date: Thu, 14 Nov 2013 16:58:03 -0800
Message-ID: <5285719b.yfNG1blUGO7K7BfS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3KOA4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 19:56:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maximlevitsky@gmail.com, akpm@linux-foundation.org

Subject: [merged] drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch removed from -mm tree
To: akpm@linux-foundation.org,maximlevitsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 16:58:03 -0800


The patch titled
     Subject: drivers/memstick/core/ms_block.c: fix spelling of MSB_RP_RECIVE_STATUS_REG
has been removed from the -mm tree.  Its filename was
     drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/memstick/core/ms_block.c: fix spelling of MSB_RP_RECIVE_STATUS_REG

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    6 +++---
 drivers/memstick/core/ms_block.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg
+++ a/drivers/memstick/core/ms_block.c
@@ -401,10 +401,10 @@ again:
 			sizeof(struct ms_status_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECIVE_STATUS_REG;
+		msb->state = MSB_RP_RECEIVE_STATUS_REG;
 		return 0;
 
-	case MSB_RP_RECIVE_STATUS_REG:
+	case MSB_RP_RECEIVE_STATUS_REG:
 		msb->regs.status = *(struct ms_status_register *)mrq->data;
 		msb->state = MSB_RP_SEND_OOB_READ;
 		/* fallthrough */
@@ -415,7 +415,7 @@ again:
 			sizeof(struct ms_extra_data_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECIVE_STATUS_REG;
+		msb->state = MSB_RP_RECEIVE_STATUS_REG;
 		return 0;
 
 	case MSB_RP_RECEIVE_OOB_READ:
diff -puN drivers/memstick/core/ms_block.h~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg drivers/memstick/core/ms_block.h
--- a/drivers/memstick/core/ms_block.h~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg
+++ a/drivers/memstick/core/ms_block.h
@@ -223,7 +223,7 @@ enum msb_readpage_states {
 	MSB_RP_RECEIVE_INT_REQ_RESULT,
 
 	MSB_RP_SEND_READ_STATUS_REG,
-	MSB_RP_RECIVE_STATUS_REG,
+	MSB_RP_RECEIVE_STATUS_REG,
 
 	MSB_RP_SEND_OOB_READ,
 	MSB_RP_RECEIVE_OOB_READ,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
tree-wide-use-reinit_completion-instead-of-init_completion.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety.patch
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

