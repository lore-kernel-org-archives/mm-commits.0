From: akpm@linux-foundation.org
Subject: [merged] fs-nls-makefile-remove-bogus-config_-assignments.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:56:07 -0700
Message-ID: <20120605195608.145A0A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34532 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FET4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:56:09 -0400
Received: by vcbfl13 with SMTP id fl13so631474vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:56:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, phcoder@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nls/Makefile: remove bogus CONFIG_ assignments
has been removed from the -mm tree.  Its filename was
     fs-nls-makefile-remove-bogus-config_-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/nls/Makefile: remove bogus CONFIG_ assignments

I assume these were debug things whcih snuck through.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nls/Makefile |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN fs/nls/Makefile~fs-nls-makefile-remove-bogus-config_-assignments fs/nls/Makefile
--- a/fs/nls/Makefile~fs-nls-makefile-remove-bogus-config_-assignments
+++ a/fs/nls/Makefile
@@ -2,18 +2,6 @@
 # Makefile for native language support
 #
 
-CONFIG_NLS_MACCELTIC=m
-CONFIG_NLS_MACCENTEURO=m
-CONFIG_NLS_MACCROATIAN=m
-CONFIG_NLS_MACCYRILLIC=m
-CONFIG_NLS_MACGAELIC=m
-CONFIG_NLS_MACGREEK=m
-CONFIG_NLS_MACICELAND=m
-CONFIG_NLS_MACINUIT=m
-CONFIG_NLS_MACROMANIAN=m
-CONFIG_NLS_MACROMAN=m
-CONFIG_NLS_MACTURKISH=m
-
 obj-$(CONFIG_NLS)		+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

