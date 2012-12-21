From: akpm@linux-foundation.org
Subject: + backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:30:24 -0800
Message-ID: <20121221223025.C240720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:37060 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2LUWa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:30:28 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so276261wib.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:30:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Milo.Kim@ti.com


The patch titled
     Subject: backlight-add-new-lp8788-backlight-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch

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
Subject: backlight-add-new-lp8788-backlight-driver-checkpatch-fixes


WARNING: please write a paragraph that describes the config symbol fully
#45: FILE: drivers/video/backlight/Kconfig:380:
+config BACKLIGHT_LP8788

ERROR: code indent should use tabs where possible
#446: FILE: include/linux/mfd/lp8788.h:242:
+^I^I            Only valid when bl_mode is LP8788_BL_COMB_PWM_BASED$

total: 1 errors, 1 warnings, 403 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/backlight-add-new-lp8788-backlight-driver.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kim, Milo" <Milo.Kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mfd/lp8788.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver-checkpatch-fixes include/linux/mfd/lp8788.h
--- a/include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver-checkpatch-fixes
+++ a/include/linux/mfd/lp8788.h
@@ -239,7 +239,7 @@ struct lp8788_charger_platform_data {
  * @fall_time             : brightness ramp down step time
  * @pwm_pol               : pwm polarity setting when bl_mode is pwm based
  * @period_ns             : platform specific pwm period value. unit is nano.
-		            Only valid when bl_mode is LP8788_BL_COMB_PWM_BASED
+			    Only valid when bl_mode is LP8788_BL_COMB_PWM_BASED
  */
 struct lp8788_backlight_platform_data {
 	char *name;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
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
cma-use-unsigned-type-for-count-argument-fix.patch
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
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

