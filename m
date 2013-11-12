From: akpm@linux-foundation.org
Subject: [folded-merged]
 gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:45:19 -0800
Message-ID: <5282af7f.UAZ+kPalc66G0DJd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3KLWpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:45:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fhrbata@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:45:19 -0800


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-fix-fix
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch

This patch was dropped because it was folded into gcov-add-support-for-gcc-47-gcov-format.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: gcov-add-support-for-gcc-47-gcov-format-fix-fix

checkpatch whined about the argument order

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-fix kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-fix
+++ a/kernel/gcov/gcc_4_7.c
@@ -266,8 +266,8 @@ struct gcov_info *gcov_info_dup(struct g
 	if (!dup->filename)
 		goto err_free;
 
-	dup->functions = kcalloc(sizeof(struct gcov_fn_info *),
-				 info->n_functions, GFP_KERNEL);
+	dup->functions = kcalloc(info->n_functions,
+				 sizeof(struct gcov_fn_info *), GFP_KERNEL);
 	if (!dup->functions)
 		goto err_free;
 
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
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

