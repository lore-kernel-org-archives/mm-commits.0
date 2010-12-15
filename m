From: akpm@linux-foundation.org
Subject: [merged] headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Dec 2010 13:04:59 -0800
Message-ID: <201012152107.oBFL7e79006032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab0LOVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 16:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, mmarek@suse.cz, randy.dunlap@oracle.com, shemminger@vyatta.com, virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#25: FILE: scripts/headers_check.pl:69:
+^I^I              "userspace cannot reference function or " .$

total: 1 errors, 0 warnings, 10 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/headers_check-better-search-for-functions-in-headers-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/headers_check.pl~headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes scripts/headers_check.pl
--- a/scripts/headers_check.pl~headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes
+++ a/scripts/headers_check.pl
@@ -66,7 +66,7 @@ sub check_declarations
 {
 	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
-		              "userspace cannot reference function or " .
+			      "userspace cannot reference function or " .
 			      "variable defined in the kernel\n";
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
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
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
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
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

