From: akpm@linux-foundation.org
Subject: + pci-calgary-fix-function-declaration.patch added to -mm tree
Date: Thu, 07 Aug 2008 16:32:29 -0700
Message-ID: <200808072332.m77NWTeB011508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYHGXdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 19:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mulix@mulix.org


The patch titled
     pci-calgary: fix function declaration
has been added to the -mm tree.  Its filename is
     pci-calgary-fix-function-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

gru-fix-preprocessor-symbol-for-sparse.patch
pci-calgary-fix-function-declaration.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
git-kbuild-fixes.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
bnx2x-fix-logical-op.patch
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

