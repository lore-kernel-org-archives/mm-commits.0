From: akpm@linux-foundation.org
Subject: [merged] tools-testing-selftests-makefile-rearrange-targets.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:18:07 -0800
Message-ID: <20130228201807.9CE295A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54394 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3B1USI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:08 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261680qaj.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:18:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/Makefile: rearrange targets
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-makefile-rearrange-targets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools/testing/selftests/Makefile: rearrange targets

Do it one-per-line to reduce patch conflict pain.

Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/Makefile~tools-testing-selftests-makefile-rearrange-targets tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~tools-testing-selftests-makefile-rearrange-targets
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,10 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
+TARGETS = breakpoints
+TARGETS += kcmp
+TARGETS += mqueue
+TARGETS += vm
+TARGETS += cpu-hotplug
+TARGETS += memory-hotplug
+TARGETS += efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \
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

