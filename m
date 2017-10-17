From: akpm@linux-foundation.org
Subject: +
 mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 16:35:41 -0700
Message-ID: <20171017233541.flsUHkCHl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761589AbdJQXfn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-migrate-type-checks-from-has_unmovable_pages-fix
has been added to the -mm tree.  Its filename is
     mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch

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
Subject: mm-drop-migrate-type-checks-from-has_unmovable_pages-fix

remove unused local `mt'

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages-fix
+++ a/mm/page_alloc.c
@@ -7352,7 +7352,6 @@ bool has_unmovable_pages(struct zone *zo
 			 bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, iter, found;
-	int mt;
 
 	/*
 	 * For avoiding noise data, lru_add_drain_all() should be called
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

