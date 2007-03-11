From: akpm@linux-foundation.org
Subject: + some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:34:34 -0800
Message-ID: <200703110934.l2B9YYYY008937@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXCKJer (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, randy.dunlap@oracle.com


The patch titled
     Some grammatical fixups and additions to atomic.h kernel-doc content
has been added to the -mm tree.  Its filename is
     some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Some grammatical fixups and additions to atomic.h kernel-doc content
From: "Robert P. J. Day" <rpjday@mindspring.com>

Tweak and add content for extractable documentation in asm-i386/atomic.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/atomic.h~some-grammatical-fixups-and-additions-to-atomich-kernel-doc include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~some-grammatical-fixups-and-additions-to-atomich-kernel-doc
+++ a/include/asm-i386/atomic.h
@@ -51,7 +51,7 @@ static __inline__ void atomic_add(int i,
 }
 
 /**
- * atomic_sub - subtract the atomic variable
+ * atomic_sub - subtract integer from atomic variable
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
  * 
@@ -170,7 +170,7 @@ static __inline__ int atomic_add_negativ
 }
 
 /**
- * atomic_add_return - add and return
+ * atomic_add_return - add integer and return
  * @v: pointer of type atomic_t
  * @i: integer value to add
  *
@@ -202,6 +202,13 @@ no_xadd: /* Legacy 386 processor */
 #endif
 }
 
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
 static __inline__ int atomic_sub_return(int i, atomic_t *v)
 {
 	return atomic_add_return(-i,v);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

remove-unused-header-file-sound-pci-cs46xx-imgs-cwcemb80h.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
remove-unused-header-file-drivers-char-drm-via_mmh.patch
mtd-correct-misspelled-preprocessor-variable.patch
jffs2-remove-superfluous-source-file-fs-jffs2-comprtestc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
delete-superfluous-source-file-net-wanrouter-af_wanpipec.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
