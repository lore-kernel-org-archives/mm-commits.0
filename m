From: akpm@linux-foundation.org
Subject: [folded-merged] aio-dont-include-aioh-in-schedh-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:43:21 -0700
Message-ID: <20130507194321.EFA615A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39021 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3EGTnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:43:23 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so100008vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:43:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio-dont-include-aioh-in-schedh-fix
has been removed from the -mm tree.  Its filename was
     aio-dont-include-aioh-in-schedh-fix.patch

This patch was dropped because it was folded into aio-dont-include-aioh-in-schedh.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: aio-dont-include-aioh-in-schedh-fix

fs/bio.c: In function 'bio_alloc_bioset':
fs/bio.c:394: error: 'UIO_MAXIOV' undeclared (first use in this function)
fs/bio.c:394: error: (Each undeclared identifier is reported only once
fs/bio.c:394: error: for each function it appears in.)
fs/bio.c: In function 'bio_alloc_map_data':
fs/bio.c:963: error: 'UIO_MAXIOV' undeclared (first use in this function)
make[1]: *** [fs/bio.o] Error 1
make: *** [fs/bio.o] Error 2

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/bio.c~aio-dont-include-aioh-in-schedh-fix fs/bio.c
--- a/fs/bio.c~aio-dont-include-aioh-in-schedh-fix
+++ a/fs/bio.c
@@ -19,6 +19,7 @@
 #include <linux/swap.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/uio.h>
 #include <linux/iocontext.h>
 #include <linux/slab.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch
mm-vmallocc-add-vfree-comment.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

