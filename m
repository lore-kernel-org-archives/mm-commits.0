From: akpm@linux-foundation.org
Subject: +
 memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch added to
 -mm tree
Date: Wed, 22 May 2013 15:45:54 -0700
Message-ID: <519d4aa2.KIUfXeZTzsMz4mre%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab3EVWpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 18:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, cody@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch added to -mm tree
To: akpm@linux-foundation.org,cody@linux.vnet.ibm.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 15:45:54 -0700


The patch titled
     Subject: memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix
has been added to the -mm tree.  Its filename is
     memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch

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
Subject: memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix

fix build

Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix
+++ a/mm/memory_hotplug.c
@@ -1492,6 +1492,7 @@ static int __ref __offline_pages(unsigne
 	unsigned long pfn, nr_pages, expire;
 	long offlined_pages;
 	int ret, drain, retry_max, node;
+	unsigned long flags;
 	struct zone *zone;
 	struct memory_notify arg;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-101.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

