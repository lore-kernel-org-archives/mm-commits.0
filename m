From: akpm@linux-foundation.org
Subject: - selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:47:02 -0700
Message-ID: <200804280747.m3S7l2C3014744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765120AbYD1HrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#54: FILE: include/linux/audit.h:373:
+	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */

ERROR: use tabs not spaces
#286: FILE: security/selinux/include/audit.h:55:
+                             struct audit_context *actx);$

WARNING: line over 80 characters
#291: FILE: security/selinux/include/audit.h:60:
+ *	Returns 1 if there are selinux fields specified in the rule, 0 otherwise.

total: 1 errors, 2 warnings, 335 lines checked

./patches/selinux-use-new-audit-hooks-remove-redundant-exports.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/include/audit.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN security/selinux/include/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes security/selinux/include/audit.h
--- a/security/selinux/include/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes
+++ a/security/selinux/include/audit.h
@@ -52,12 +52,13 @@ void selinux_audit_rule_free(void *rule)
  *	-errno on failure.
  */
 int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *rule,
-                             struct audit_context *actx);
+			     struct audit_context *actx);
 
 /**
  *	selinux_audit_rule_known - check to see if rule contains selinux fields.
  *	@rule: rule to be checked
- *	Returns 1 if there are selinux fields specified in the rule, 0 otherwise.
+ *	Returns 1 if there are selinux fields specified in the rule, 0
+ *	otherwise.
  */
 int selinux_audit_rule_known(struct audit_krule *krule);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-add-power-management-functionality.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc.patch
pnp-use-dev_printk-for-quirk-messages.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
fat_valid_media-remove-pointless-test.patch

