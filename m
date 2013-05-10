From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 10 May 2013 11:42:21 -0700
Message-ID: <20130510184221.623ED31C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60506 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3EJSmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 14:42:22 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so422201vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 11:42:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kvm/kvm_mips.c                           |   12 -----------
 drivers/md/persistent-data/dm-space-map-metadata.c |    4 ---
 2 files changed, 16 deletions(-)

diff -puN arch/mips/kvm/kvm_mips.c~linux-next-git-rejects arch/mips/kvm/kvm_mips.c
--- a/arch/mips/kvm/kvm_mips.c~linux-next-git-rejects
+++ a/arch/mips/kvm/kvm_mips.c
@@ -209,29 +209,17 @@ int kvm_arch_create_memslot(struct kvm_m
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-<<<<<<< HEAD
-                                struct kvm_memory_slot *memslot,
-                                struct kvm_userspace_memory_region *mem,
-                                enum kvm_mr_change change)
-=======
 				   struct kvm_memory_slot *memslot,
 				   struct kvm_memory_slot old,
 				   struct kvm_userspace_memory_region *mem,
 				   bool user_alloc)
->>>>>>> linux-next/akpm-base
 {
 	return 0;
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-<<<<<<< HEAD
-                                struct kvm_userspace_memory_region *mem,
-                                const struct kvm_memory_slot *old,
-                                enum kvm_mr_change change)
-=======
 				   struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot old, bool user_alloc)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long npages = 0;
 	int i, err = 0;
diff -puN drivers/md/persistent-data/dm-space-map-metadata.c~linux-next-git-rejects drivers/md/persistent-data/dm-space-map-metadata.c
--- a/drivers/md/persistent-data/dm-space-map-metadata.c~linux-next-git-rejects
+++ a/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -465,11 +465,7 @@ static struct dm_space_map ops = {
 	.commit = sm_metadata_commit,
 	.root_size = sm_metadata_root_size,
 	.copy_root = sm_metadata_copy_root,
-<<<<<<< HEAD
-	.register_threshold_callback = sm_metadata_register_threshold_callback
-=======
 	.register_threshold_callback = NULL
->>>>>>> linux-next/akpm-base
 };
 
 /*----------------------------------------------------------------*/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipcsem-fix-semctl-getzcnt-fix.patch
ipcsem-fix-semctl-getncnt-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
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
linux-next-git-rejects.patch

