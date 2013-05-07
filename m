From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-net-rename-random32-to-prandom_u32-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:39:58 -0700
Message-ID: <20130507193958.9E6A55A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34586 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EGTkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:40:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so99790yho.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:39:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-net-rename-random32-to-prandom_u32-fix
has been removed from the -mm tree.  Its filename was
     drivers-net-rename-random32-to-prandom_u32-fix.patch

This patch was dropped because it was folded into drivers-net-rename-random32-to-prandom_u32.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-net-rename-random32-to-prandom_u32-fix

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/team/team_mode_random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/team/team_mode_random.c~drivers-net-rename-random32-to-prandom_u32-fix drivers/net/team/team_mode_random.c
--- a/drivers/net/team/team_mode_random.c~drivers-net-rename-random32-to-prandom_u32-fix
+++ a/drivers/net/team/team_mode_random.c
@@ -18,7 +18,7 @@
 
 static u32 random_N(unsigned int N)
 {
-	return reciprocal_divide(random32(), N);
+	return reciprocal_divide(prandom_u32(), N);
 }
 
 static bool rnd_transmit(struct team *team, struct sk_buff *skb)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch
mm-vmallocc-add-vfree-comment.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
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

