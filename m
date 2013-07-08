From: akpm@linux-foundation.org
Subject: [folded-merged]
 panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:28:38 -0700
Message-ID: <51db3d16.9do9pqQzI9YB0Hzr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHW2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, athorlton@sgi.com, akpm@linux-foundation.org

Subject: [folded-merged] panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,athorlton@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:28:38 -0700


The patch titled
     Subject: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
has been removed from the -mm tree.  Its filename was
     panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch

This patch was dropped because it was folded into panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix

remove stray quote

Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix kernel/panic.c
--- a/kernel/panic.c~panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
+++ a/kernel/panic.c
@@ -400,7 +400,7 @@ static void warn_slowpath_common(const c
 				 unsigned taint, struct slowpath_args *args)
 {
 	pr_warn("------------[ cut here ]------------\n");
-	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",  '
+	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

