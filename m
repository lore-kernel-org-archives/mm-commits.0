From: akpm@linux-foundation.org
Subject: [folded-dropped] core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:06:32 -0800
Message-ID: <20121218220633.17A0C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:65235 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:06:35 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so67474bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:06:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes

ERROR: code indent should use tabs where possible
#40: FILE: fs/coredump.c:169:
+ ^I^I * We have 2 | tokens at the head of core_pattern which$

WARNING: please, no space before tabs
#40: FILE: fs/coredump.c:169:
+ ^I^I * We have 2 | tokens at the head of core_pattern which$

total: 1 errors, 1 warnings, 28 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes fs/coredump.c
--- a/fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes
+++ a/fs/coredump.c
@@ -166,10 +166,10 @@ static int format_corename(struct core_n
 
 	if (ispipe && pat_ptr[1] == '|') {
 		/*
- 		 * We have 2 | tokens at the head of core_pattern which
- 		 * indicates we are a pipe and the reader should inherit the
- 		 * namespaces of the crashing process
- 		 */
+		 * We have 2 | tokens at the head of core_pattern which
+		 * indicates we are a pipe and the reader should inherit the
+		 * namespaces of the crashing process
+		 */
 		cprm->switch_ns = true;
 		pat_ptr++;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

