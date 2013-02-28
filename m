From: akpm@linux-foundation.org
Subject: [folded-dropped] backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:37:57 -0800
Message-ID: <20130228003758.61DDC31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:42067 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3B1Ah7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:37:59 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so138575vea.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:37:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Milo.Kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-new-lp8788-backlight-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch

This patch was dropped because it was folded into backlight-add-new-lp8788-backlight-driver.patch

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
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

