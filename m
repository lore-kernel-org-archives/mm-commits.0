From: akpm@linux-foundation.org
Subject: + avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:00:39 -0700
Message-ID: <20120613210039.D1B4AA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58665 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2FMVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:00:47 -0400
Received: by eeit10 with SMTP id t10so55505eei.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:00:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, consul.kautuk@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mohdfarisq2010@gmail.com


The patch titled
     Subject: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
has been added to the -mm tree.  Its filename is
     avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch

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
Subject: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix

fix comment layput

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Mohd. Faris <mohdfarisq2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/fault.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix
+++ a/arch/avr32/mm/fault.c
@@ -153,11 +153,11 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
-			 * have already released it in __lock_page_or_retry
-			 * in mm/filemap.c.
+			/*
+			 * No need to up_read(&mm->mmap_sem) as we would have
+			 * already released it in __lock_page_or_retry() in
+			 * mm/filemap.c.
 			 */
-
 			goto retry;
 		}
 	}
_
Subject: Subject: avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

