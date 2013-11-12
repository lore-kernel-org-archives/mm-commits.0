From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-factor-commit-limit-calculation-fix-fix-fix.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:36:42 -0800
Message-ID: <5282ad7a./8U+SEQTQp1999Ws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3KLWgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-factor-commit-limit-calculation-fix-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:36:42 -0800


The patch titled
     Subject: mm-factor-commit-limit-calculation-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-factor-commit-limit-calculation-fix-fix-fix.patch

This patch was dropped because it was folded into mm-factor-commit-limit-calculation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-commit-limit-calculation-fix-fix-fix

Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/util.c~mm-factor-commit-limit-calculation-fix-fix-fix mm/util.c
--- a/mm/util.c~mm-factor-commit-limit-calculation-fix-fix-fix
+++ a/mm/util.c
@@ -402,7 +402,7 @@ struct address_space *page_mapping(struc
 }
 
 /*
- * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ * Committed memory limit enforced when OVERCOMMIT_NEVER policy is used
  */
 unsigned long vm_commit_limit(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

