From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:55 -0800
Message-ID: <58b5e2eb.UedIzhQK+xUbcOfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdB1Uv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overwriten" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "overwriten" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  overwrien||overwritten

Link: http://lkml.kernel.org/r/1481573103-11329-30-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib_iba6120.c  |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c  |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c  |    2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c  |    2 +-
 drivers/parport/parport_pc.c             |    2 +-
 scripts/spelling.txt                     |    1 +
 sound/pci/cs46xx/cs46xx_dsp_task_types.h |    2 +-
 7 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/infiniband/hw/qib/qib_iba6120.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances drivers/infiniband/hw/qib/qib_iba6120.c
--- a/drivers/infiniband/hw/qib/qib_iba6120.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -707,7 +707,7 @@ static void qib_6120_clear_freeze(struct
 	/* disable error interrupts, to avoid confusion */
 	qib_write_kreg(dd, kr_errmask, 0ULL);
 
-	/* also disable interrupts; errormask is sometimes overwriten */
+	/* also disable interrupts; errormask is sometimes overwritten */
 	qib_6120_set_intr_state(dd, 0);
 
 	qib_cancel_sends(dd->pport);
diff -puN drivers/infiniband/hw/qib/qib_iba7220.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances drivers/infiniband/hw/qib/qib_iba7220.c
--- a/drivers/infiniband/hw/qib/qib_iba7220.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1259,7 +1259,7 @@ static void qib_7220_clear_freeze(struct
 	/* disable error interrupts, to avoid confusion */
 	qib_write_kreg(dd, kr_errmask, 0ULL);
 
-	/* also disable interrupts; errormask is sometimes overwriten */
+	/* also disable interrupts; errormask is sometimes overwritten */
 	qib_7220_set_intr_state(dd, 0);
 
 	qib_cancel_sends(dd->pport);
diff -puN drivers/infiniband/hw/qib/qib_iba7322.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances drivers/infiniband/hw/qib/qib_iba7322.c
--- a/drivers/infiniband/hw/qib/qib_iba7322.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2053,7 +2053,7 @@ static void qib_7322_clear_freeze(struct
 			qib_write_kreg_port(dd->pport + pidx, krp_errmask,
 					    0ULL);
 
-	/* also disable interrupts; errormask is sometimes overwriten */
+	/* also disable interrupts; errormask is sometimes overwritten */
 	qib_7322_set_intr_state(dd, 0);
 
 	/* clear the freeze, and be sure chip saw it */
diff -puN drivers/isdn/hardware/mISDN/mISDNipac.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances drivers/isdn/hardware/mISDN/mISDNipac.c
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -1625,7 +1625,7 @@ mISDNipac_init(struct ipac_hw *ipac, voi
 		ipac->hscx[i].bch.hw = hw;
 		ipac->hscx[i].ip = ipac;
 		/* default values for IOM time slots
-		 * can be overwriten by card */
+		 * can be overwritten by card */
 		ipac->hscx[i].slot = (i == 0) ? 0x2f : 0x03;
 	}
 
diff -puN drivers/parport/parport_pc.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/drivers/parport/parport_pc.c
@@ -902,7 +902,7 @@ static size_t parport_pc_ecp_write_block
  *	******************************************
  */
 
-/* GCC is not inlining extern inline function later overwriten to non-inline,
+/* GCC is not inlining extern inline function later overwritten to non-inline,
    so we use outlined_ variants here.  */
 static const struct parport_operations parport_pc_ops = {
 	.write_data	= parport_pc_write_data,
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -734,6 +734,7 @@ overrided||overridden
 overriden||overridden
 overun||overrun
 overwritting||overwriting
+overwriten||overwritten
 pacakge||package
 pachage||package
 packacge||package
diff -puN sound/pci/cs46xx/cs46xx_dsp_task_types.h~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances sound/pci/cs46xx/cs46xx_dsp_task_types.h
--- a/sound/pci/cs46xx/cs46xx_dsp_task_types.h~scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances
+++ a/sound/pci/cs46xx/cs46xx_dsp_task_types.h
@@ -203,7 +203,7 @@ struct dsp_task_tree_context_block {
 
 	u32	  saverfe;					
 
-	/* Value may be overwriten by stack save algorithm.
+	/* Value may be overwritten by stack save algorithm.
 	   Retain the size of the stack data saved here if used */
 	___DSP_DUAL_16BIT_ALLOC(
              reserved1,	
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

