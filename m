From: akpm@linux-foundation.org
Subject: + mm-add-overcommit_kbytes-sysctl-variable-fix.patch added to -mm tree
Date: Tue, 03 Dec 2013 14:15:05 -0800
Message-ID: <529e57e9.vZ8nOV44xRwVq42W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3LCWPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:15:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org

Subject: + mm-add-overcommit_kbytes-sysctl-variable-fix.patch added to -mm tree
To: akpm@linux-foundation.org,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com,jmarchan@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:15:05 -0800


The patch titled
     Subject: mm-add-overcommit_kbytes-sysctl-variable-fix
has been added to the -mm tree.  Its filename is
     mm-add-overcommit_kbytes-sysctl-variable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-overcommit_kbytes-sysctl-variable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-overcommit_kbytes-sysctl-variable-fix.patch

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
Subject: mm-add-overcommit_kbytes-sysctl-variable-fix

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable-fix
+++ a/Documentation/sysctl/vm.txt
@@ -581,7 +581,7 @@ When overcommit_memory is set to 2, the
 permitted to exceed swap plus this amount of physical RAM. See below.
 
 Note: overcommit_kbytes is the counterpart of overcommit_ratio. Only one
-of them may be specified at a time. Setting one disable the other (which
+of them may be specified at a time. Setting one disables the other (which
 then appears as 0 when read).
 
 ==============================================================
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

