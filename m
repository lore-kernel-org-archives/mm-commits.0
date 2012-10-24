From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 24 Oct 2012 15:10:12 -0700
Message-ID: <20121024221012.7CEDD1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33402 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238Ab2JXWKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 18:10:13 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so273592qae.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 15:10:12 -0700 (PDT)
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

 arch/alpha/kernel/osf_sys.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~linux-next-git-rejects arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~linux-next-git-rejects
+++ a/arch/alpha/kernel/osf_sys.c
@@ -906,17 +906,10 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned
 		unsigned __user *p = buffer;
 		unsigned i;
 		
-<<<<<<< HEAD
-		for (i = 0, p = buffer; i < nbytes; ++i, p += 2) {
-			unsigned v, w, status;
-
-			if (get_user(v, p) || get_user(w, p + 1))
-=======
  		for (i = 0, p = buffer; i < nbytes; ++i, p += 2) {
 			unsigned v, w, status;
 
  			if (get_user(v, p) || get_user(w, p + 1))
->>>>>>> linux-next/akpm-base
  				return -EFAULT;
  			switch (v) {
  			case SSIN_UACPROC:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
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
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

