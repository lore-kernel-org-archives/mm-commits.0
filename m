From: akpm@linux-foundation.org
Subject: [merged] dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:36 -0800
Message-ID: <20130228201736.A350731C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39827 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1URh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:37 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so245166ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jj@chaosbits.net, konrad.wilk@oracle.com, shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/DMA-API-HOWTO.txt: fix typo
has been removed from the -mm tree.  Its filename was
     dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/DMA-API-HOWTO.txt: fix typo

Noted by Jesper

Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -752,7 +752,7 @@ Example 1:
 		dma_unmap_single(dma_handle1);
 	map_error_handling1:
 
-Example 2: (if buffers are allocated a loop, unmap all mapped buffers when
+Example 2: (if buffers are allocated in a loop, unmap all mapped buffers when
 	    mapping error is detected in the middle)
 
 	dma_addr_t dma_addr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

