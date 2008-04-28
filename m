From: akpm@linux-foundation.org
Subject: - audit-final-renamings-and-cleanup-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:47:10 -0700
Message-ID: <200804280747.m3S7lAeR014748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765580AbYD1HrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     audit-final-renamings-and-cleanup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     audit-final-renamings-and-cleanup-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit-final-renamings-and-cleanup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#171: FILE: kernel/auditsc.c:537:
+^I^I^I^I                                  f->lsm_rule,$

ERROR: use tabs not spaces
#186: FILE: kernel/auditsc.c:553:
+^I^I^I^I^I           f->lsm_rule, ctx);$

WARNING: line over 80 characters
#202: FILE: kernel/auditsc.c:572:
+							if (security_audit_rule_match(axi->osid, f->type, f->op, f->lsm_rule, ctx)) {

total: 2 errors, 1 warnings, 161 lines checked

./patches/audit-final-renamings-and-cleanup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~audit-final-renamings-and-cleanup-checkpatch-fixes kernel/auditsc.c
--- a/kernel/auditsc.c~audit-final-renamings-and-cleanup-checkpatch-fixes
+++ a/kernel/auditsc.c
@@ -534,7 +534,7 @@ static int audit_filter_rules(struct tas
 				}
 				result = security_audit_rule_match(sid, f->type,
 				                                  f->op,
-				                                  f->lsm_rule,
+								  f->lsm_rule,
 				                                  ctx);
 			}
 			break;
@@ -550,7 +550,7 @@ static int audit_filter_rules(struct tas
 				if (name) {
 					result = security_audit_rule_match(
 					           name->osid, f->type, f->op,
-					           f->lsm_rule, ctx);
+						   f->lsm_rule, ctx);
 				} else if (ctx) {
 					for (j = 0; j < ctx->name_count; j++) {
 						if (security_audit_rule_match(
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

