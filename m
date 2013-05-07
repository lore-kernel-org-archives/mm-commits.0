From: akpm@linux-foundation.org
Subject: [to-be-updated] rapidio-make-enumeration-discovery-configurable-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 13:08:53 -0700
Message-ID: <20130507200854.2E98131C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:64724 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3EGUIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 16:08:55 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so103706vea.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 13:08:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@Prodrive.nl, galak@kernel.crashing.org, leoli@freescale.com, micha.nelissen@Prodrive.nl, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio-make-enumeration-discovery-configurable-fix
has been removed from the -mm tree.  Its filename was
     rapidio-make-enumeration-discovery-configurable-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rapidio-make-enumeration-discovery-configurable-fix

work around weird kbuild failure

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/Kconfig~rapidio-make-enumeration-discovery-configurable-fix drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-make-enumeration-discovery-configurable-fix
+++ a/drivers/rapidio/Kconfig
@@ -59,7 +59,7 @@ choice
 	  If unsure, select Basic built-in.
 
 config RAPIDIO_ENUM_BASIC
-	tristate "Basic"
+	bool "Basic"
 	help
 	  This option includes basic RapidIO fabric enumeration and discovery
 	  mechanism similar to one described in RapidIO specification Annex 1.
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
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
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

