From: akpm@linux-foundation.org
Subject: [alternative-merged] selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 29 Oct 2012 14:43:44 -0700
Message-ID: <20121029214345.51DB81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42752 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab2J2Vnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:43:46 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so698025vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:43:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes

WARNING: line over 80 characters
#114: FILE: tools/testing/selftests/ipc/msgque.c:61:
+		if (msgsnd(msgque->msq_id, &msgque->messages[i].mtype, msgque->messages[i].msize, IPC_NOWAIT) != 0) {

WARNING: line over 80 characters
#128: FILE: tools/testing/selftests/ipc/msgque.c:75:
+		ret = msgrcv(msgque->msq_id, &message.mtype, MAX_MSG_SIZE, 0, IPC_NOWAIT);

WARNING: line over 80 characters
#137: FILE: tools/testing/selftests/ipc/msgque.c:84:
+			printf("Wrong message size: %d (expected %d)\n", ret, msgque->messages[cnt].msize);

WARNING: line over 80 characters
#179: FILE: tools/testing/selftests/ipc/msgque.c:126:
+			printf("Failed to get stats for IPC queue with id %d\n", msgque->kern_id);

WARNING: line over 80 characters
#198: FILE: tools/testing/selftests/ipc/msgque.c:145:
+		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype, MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);

WARNING: line over 80 characters
#214: FILE: tools/testing/selftests/ipc/msgque.c:161:
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(TEST_STRING), IPC_NOWAIT) != 0) {

WARNING: line over 80 characters
#221: FILE: tools/testing/selftests/ipc/msgque.c:168:
+	if (msgsnd(msgque->msq_id, &msgbuf.mtype, sizeof(ANOTHER_TEST_STRING), IPC_NOWAIT) != 0) {

WARNING: space prohibited between function name and open parenthesis '('
#228: FILE: tools/testing/selftests/ipc/msgque.c:175:
+int main (int argc, char **argv)

total: 0 errors, 8 warnings, 256 lines checked

./patches/selftests-ipc-message-queue-copy-feature-test.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/ipc/msgque.c~selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes tools/testing/selftests/ipc/msgque.c
--- a/tools/testing/selftests/ipc/msgque.c~selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -172,7 +172,7 @@ int fill_msgque(struct msgque_data *msgq
 	return 0;
 }
 
-int main (int argc, char **argv)
+int main(int argc, char **argv)
 {
 	key_t key;
 	int msg, pid, err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

