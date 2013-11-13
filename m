From: akpm@linux-foundation.org
Subject: +
 drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch added to -mm tree
Date: Wed, 13 Nov 2013 12:34:04 -0800
Message-ID: <5283e23c.1TlNjU4+1kIYWY9C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3KMUeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maximlevitsky@gmail.com, akpm@linux-foundation.org

Subject: + drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch added to -mm tree
To: akpm@linux-foundation.org,maximlevitsky@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:34:04 -0800


The patch titled
     Subject: drivers/memstick/core/ms_block.c: fix spelling in MSB_RP_RECIVE_STATUS_REG
has been added to the -mm tree.  Its filename is
     drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch

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
Subject: drivers/memstick/core/ms_block.c: fix spelling in MSB_RP_RECIVE_STATUS_REG

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 drivers/memstick/core/ms_block.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg
+++ a/drivers/memstick/core/ms_block.c
@@ -401,7 +401,7 @@ again:
 			sizeof(struct ms_status_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECIVE_STATUS_REG;
+		msb->state = MSB_RP_RECEIVE_STATUS_REG;
 		return 0;
 
 	case MSB_RP_RECIVE_STATUS_REG:
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
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
ipc-msg-fix-message-length-check-for-negative-values.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

