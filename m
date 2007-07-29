From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-for-kmodc.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:07 -0700
Message-ID: <200707290611.l6T6B771010962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756699AbXG2GLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc fix for kmod.c
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-for-kmodc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc fix for kmod.c
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kmod.c:
Warning(linux-2.6.23-rc1//kernel/kmod.c:364): No description found for parameter 'envp'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/kmod.c~kernel-doc-fix-for-kmodc kernel/kmod.c
--- a/kernel/kmod.c~kernel-doc-fix-for-kmodc
+++ a/kernel/kmod.c
@@ -351,11 +351,11 @@ static inline void register_pm_notifier_
 
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
- * @path - path to usermode executable
- * @argv - arg vector for process
- * @envp - environment for process
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
  *
- * Returns either NULL on allocation failure, or a subprocess_info
+ * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
