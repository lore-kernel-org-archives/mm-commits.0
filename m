From: akpm@linux-foundation.org
Subject: + scsi-advansysc-make-3-functions-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:18:02 -0700
Message-ID: <200711010718.lA17I2mx017808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376AbXKAHSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     scsi/advansys.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     scsi-advansysc-make-3-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi/advansys.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static
+++ a/drivers/scsi/advansys.c
@@ -12261,7 +12261,7 @@ static ushort __devinit AdvReadEEPWord(A
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12328,7 +12328,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12395,7 +12395,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_b
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
kill-udffs_dateversion.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
