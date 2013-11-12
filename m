From: akpm@linux-foundation.org
Subject: [folded-merged]
 gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:45:21 -0800
Message-ID: <5282af81.Wd+wOa2v4ZjOsHxo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3KLWpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,fhrbata@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:45:21 -0800


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch

This patch was dropped because it was folded into gcov-add-support-for-gcc-47-gcov-format.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#227: FILE: kernel/gcov/gcc_4_7.c:179:
+	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++)
+	{

ERROR: that open brace { should be on the previous line
#269: FILE: kernel/gcov/gcc_4_7.c:221:
+	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++)
+	{

total: 2 errors, 0 warnings, 574 lines checked

./patches/gcov-add-support-for-gcc-47-gcov-format.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes
+++ a/kernel/gcov/gcc_4_7.c
@@ -176,8 +176,7 @@ void gcov_info_reset(struct gcov_info *i
 	unsigned int fi_idx;
 	unsigned int ct_idx;
 
-	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++)
-	{
+	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++) {
 		ci_ptr = info->functions[fi_idx]->ctrs;
 
 		for (ct_idx = 0; ct_idx < GCOV_COUNTERS; ct_idx++) {
@@ -218,8 +217,7 @@ void gcov_info_add(struct gcov_info *dst
 	unsigned int ct_idx;
 	unsigned int val_idx;
 
-	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++)
-	{
+	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++) {
 		dci_ptr = dst->functions[fi_idx]->ctrs;
 		sci_ptr = src->functions[fi_idx]->ctrs;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
drivers-rtc-rtc-as3722-add-rtc-driver.patch
fs-hfs-btreeh-remove-duplicate-defines.patch
gcov-add-support-for-gcc-47-gcov-format.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

