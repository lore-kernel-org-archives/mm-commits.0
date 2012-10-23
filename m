From: akpm@linux-foundation.org
Subject: + dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 16:06:43 -0700
Message-ID: <20121023230644.8A59320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38493 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab2JWXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 19:06:47 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so261862wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 16:06:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jj@chaosbits.net, konrad.wilk@oracle.com, shuah.khan@hp.com


The patch titled
     Subject: documentation-dma-api-howtotxt-add-dma-mapping-error-check-usage-examples-fix
has been added to the -mm tree.  Its filename is
     dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch

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
Subject: documentation-dma-api-howtotxt-add-dma-mapping-error-check-usage-examples-fix

fix typo, per Jesper

Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -751,7 +751,7 @@ Example 1:
 		dma_unmap_single(dma_handle1);
 	map_error_handling1:
 
-Example 2: (if buffers are allocated a loop, unmap all mapped buffers when
+Example 2: (if buffers are allocated in a loop, unmap all mapped buffers when
 	    mapping error is detected in the middle)
 
 	dma_addr_t dma_addr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

