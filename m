From: akpm@linux-foundation.org
Subject: + fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:43 -0700
Message-ID: <20120820202344.85C6C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64519 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2HTUXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:46 -0400
Received: by weyr1 with SMTP id r1so311380wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
has been added to the -mm tree.  Its filename is
     fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch

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
Subject: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix

Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix fs/fat/dir.c
--- a/fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
+++ a/fs/fat/dir.c
@@ -224,7 +224,6 @@ fat_short2lower_uni(struct nls_table *t,
 			nc = *c;
 
 		charlen = t->char2uni(&nc, 1, uni);
-
 		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

