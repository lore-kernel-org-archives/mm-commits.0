From: akpm@linux-foundation.org
Subject: + hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:46:45 -0700
Message-ID: <200709262046.l8QKkjUS003103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbXIZUrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, sfr@canb.auug.org.au


The patch titled
     HVC console is also used by iSeries, so add that to HVC_DRIVER help.
has been added to the -mm tree.  Its filename is
     hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HVC console is also used by iSeries, so add that to HVC_DRIVER help.
From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/Kconfig~hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help drivers/char/Kconfig
--- a/drivers/char/Kconfig~hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help
+++ a/drivers/char/Kconfig
@@ -600,7 +600,7 @@ config HVC_DRIVER
 	bool
 	help
 	  Generic "hypervisor virtual console" infrastructure for various
-	  hypervisors (pSeries, Xen, lguest).
+	  hypervisors (pSeries, iSeries, Xen, lguest).
 	  It will automatically be selected if one of the back-end console drivers
 	  is selected.
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-modules-oopsing-in-lguest-guests.patch
lguest-example-launcher-truncates-block-device-file-to-0.patch
git-kbuild.patch
git-kvm.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
move-kasprintfo-to-obj-y.patch
delay-creation-of-khcvd-thread.patch
hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
