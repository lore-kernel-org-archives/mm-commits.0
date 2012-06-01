From: akpm@linux-foundation.org
Subject: + fs-nls-makefile-remove-bogus-config_-assignments.patch added to -mm tree
Date: Fri, 01 Jun 2012 14:58:00 -0700
Message-ID: <20120601215800.51A3DA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:43931 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933280Ab2FAV6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 17:58:06 -0400
Received: by lagr15 with SMTP id r15so143508lag.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 14:58:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, phcoder@gmail.com, yinghai@kernel.org


The patch titled
     Subject: fs/nls/Makefile: remove bogus CONFIG_ assignments
has been added to the -mm tree.  Its filename is
     fs-nls-makefile-remove-bogus-config_-assignments.patch

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
Subject: Subject: fs/nls/Makefile: remove bogus CONFIG_ assignments

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
fs-nls-makefile-remove-bogus-config_-assignments.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
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

