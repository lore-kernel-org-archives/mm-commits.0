From: akpm@linux-foundation.org
Subject: + sysctl-remove-obsolete-comments-fix.patch added to -mm tree
Date: Tue, 14 Dec 2010 13:36:56 -0800
Message-ID: <201012142136.oBELaumF011176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab0LNVh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 16:37:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bookjovi@gmail.com, hidave.darkstar@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     sysctl-remove-obsolete-comments-fix
has been added to the -mm tree.  Its filename is
     sysctl-remove-obsolete-comments-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-remove-obsolete-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix Documentation/sysctl/00-INDEX, per Dave

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Jovi Zhang <bookjovi@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments-fix Documentation/sysctl/00-INDEX
--- a/Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments-fix
+++ a/Documentation/sysctl/00-INDEX
@@ -4,8 +4,6 @@ README
 	- general information about /proc/sys/ sysctl files.
 abi.txt
 	- documentation for /proc/sys/abi/*.
-ctl_unnumbered.txt
-	- explanation of why one should not add new binary sysctl numbers.
 fs.txt
 	- documentation for /proc/sys/fs/*.
 kernel.txt
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-install_special_mapping-skips-security_file_mmap-check-fix.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

