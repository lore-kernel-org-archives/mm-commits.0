From: akpm@linux-foundation.org
Subject: + bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch added to -mm tree
Date: Wed, 02 Jan 2013 14:40:22 -0800
Message-ID: <20130102224023.09CC020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:46847 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3ABWkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:40:25 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so910094eaa.4
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:40:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.santos@pobox.com


The patch titled
     Subject: bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch

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
Subject: bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes

WARNING: please, no space before tabs
#56: FILE: include/linux/bug.h:45:
+ * ^I^I      error message.$

total: 0 errors, 1 warnings, 88 lines checked

./patches/bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daniel Santos <daniel.santos@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes include/linux/bug.h
--- a/include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes
+++ a/include/linux/bug.h
@@ -42,7 +42,7 @@ struct pt_regs;
 
 /**
  * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
- * 		      error message.
+ *		      error message.
  * @condition: the condition which the compiler should know is false.
  *
  * See BUILD_BUG_ON for description.
diff -puN include/linux/compiler.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes include/linux/compiler.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

