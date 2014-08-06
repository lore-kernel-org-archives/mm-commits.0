From: akpm@linux-foundation.org
Subject: + fsnotify-rename-event-handling-functions-checkpatch-fixes.patch added to -mm tree
Date: Wed, 06 Aug 2014 12:24:14 -0700
Message-ID: <53e280de.RU8+mBUPM5D6pyo6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:46449 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbaHFTYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:24:15 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so399210ykb.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:24:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify-rename-event-handling-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fsnotify-rename-event-handling-functions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-rename-event-handling-functions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-rename-event-handling-functions-checkpatch-fixes.patch

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
Subject: fsnotify-rename-event-handling-functions-checkpatch-fixes

WARNING: line over 80 characters
#121: FILE: fs/notify/notification.c:152:
+ * This will not remove the event, that must be done with fsnotify_remove_first_event()

WARNING: line over 80 characters
#156: FILE: include/linux/fsnotify_backend.h:332:
+extern struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group);

WARNING: line over 80 characters
#159: FILE: include/linux/fsnotify_backend.h:334:
+extern struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group);

total: 0 errors, 3 warnings, 111 lines checked

./patches/fsnotify-rename-event-handling-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/notification.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/notify/notification.c~fsnotify-rename-event-handling-functions-checkpatch-fixes fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-rename-event-handling-functions-checkpatch-fixes
+++ a/fs/notify/notification.c
@@ -149,7 +149,8 @@ struct fsnotify_event *fsnotify_remove_f
 }
 
 /*
- * This will not remove the event, that must be done with fsnotify_remove_first_event()
+ * This will not remove the event, that must be done with
+ * fsnotify_remove_first_event()
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
fsnotify-rename-event-handling-functions-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

