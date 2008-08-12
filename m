From: akpm@linux-foundation.org
Subject: - pci-calgary-fix-function-declaration.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:34 -0700
Message-ID: <200808122032.m7CKWYAN011722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbYHLUdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mulix@mulix.org, mm-commits@vger.kernel.org


The patch titled
     pci-calgary: fix function declaration
has been removed from the -mm tree.  Its filename was
     pci-calgary-fix-function-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-calgary: fix function declaration
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:

linux-next-20080807/arch/x86/kernel/pci-calgary_64.c:1353:36: warning: non-ANSI function declaration of function 'get_tce_space_from_tar'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~pci-calgary-fix-function-declaration arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~pci-calgary-fix-function-declaration
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -1350,7 +1350,7 @@ static void calgary_init_bitmap_from_tce
  * Function for kdump case. Get the tce tables from first kernel
  * by reading the contents of the base adress register of calgary iommu
  */
-static void get_tce_space_from_tar()
+static void get_tce_space_from_tar(void)
 {
 	int bus;
 	void __iomem *target;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
gru-fix-preprocessor-symbol-for-sparse.patch
move-kernel-doc-comment-for-might_sleep-directly-before-its-defining-block.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

