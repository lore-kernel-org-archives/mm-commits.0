From: akpm@linux-foundation.org
Subject: [folded-merged]
 documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:43:41 -0700
Message-ID: <51d49b0d.rBQqa7Eb7pJpVY8k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GCVnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwab@linux-m68k.org, rob@landley.net, keescook@chromium.org, akpm@linux-foundation.org

Subject: [folded-merged] documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,keescook@chromium.org,rob@landley.net,schwab@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:43:41 -0700


The patch titled
     Subject: documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch

This patch was dropped because it was folded into documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix

remove the str[cpy|dup] altogether

Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix
+++ a/Documentation/accounting/getdelays.c
@@ -299,7 +299,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			containerpath = strdup(optarg);
+			containerpath = optarg;
 			break;
 		case 'w':
 			logfile = strdup(optarg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
dump_stack-serialize-the-output-from-dump_stack.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
dev-oldmem-remove-the-interface.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

