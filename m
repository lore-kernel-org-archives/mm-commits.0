From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:48:49 -0800
Message-ID: <20121218224849.ED8B5200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:46037 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRWsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:48:52 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so68670wgb.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:48:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-add-sysctl-to-specify-desired-next-object-id.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#123: FILE: ipc/util.c:285:
+		if(ids->seq > ids->seq_max)

total: 1 errors, 0 warnings, 94 lines checked

./patches/ipc-add-sysctl-to-specify-desired-next-object-id.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/util.c~ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes ipc/util.c
--- a/ipc/util.c~ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes
+++ a/ipc/util.c
@@ -282,7 +282,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	if (next_id < 0) {
 		new->seq = ids->seq++;
-		if(ids->seq > ids->seq_max)
+		if (ids->seq > ids->seq_max)
 			ids->seq = 0;
 	} else {
 		new->seq = ipcid_to_seqx(next_id);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
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
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

