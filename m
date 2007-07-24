From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-for-kmodc.patch added to -mm tree
Date: Mon, 23 Jul 2007 21:53:40 -0700
Message-ID: <200707240453.l6O4rede029019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbXGXEyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 00:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc fix for kmod.c
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-for-kmodc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-hugetlb-page-allocation-leak.patch
kernel-doc-fix-for-kmodc.patch
git-acpi.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
