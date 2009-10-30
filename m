From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-kernel-janitors-after-mismerge.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:49:14 -0700
Message-ID: <200910302049.n9UKnEXN007778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757499AbZJ3Utk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update Kernel Janitors after mismerge
has been removed from the -mm tree.  Its filename was
     maintainers-update-kernel-janitors-after-mismerge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update Kernel Janitors after mismerge
From: Joe Perches <joe@perches.com>

Fix the mismerge of the W: URL and the S: status fields.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-update-kernel-janitors-after-mismerge MAINTAINERS
--- a/MAINTAINERS~maintainers-update-kernel-janitors-after-mismerge
+++ a/MAINTAINERS
@@ -2991,8 +2991,8 @@ F:	scripts/Makefile.*
 
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
-W:	http://www.kerneljanitors.org/
-S:	Maintained
+W:	http://janitor.kernelnewbies.org/
+S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

