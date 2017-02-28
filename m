From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:13 -0800
Message-ID: <58b5e2c1.yjYPqt0J30VhhRp9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdB1Uvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "an one" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "an one" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  an one||a one

I dropped the "an" before "one or more" in
drivers/net/ethernet/sfc/mcdi_pcol.h.

Link: http://lkml.kernel.org/r/1481573103-11329-6-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/vtime.c             |    2 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h |    2 +-
 drivers/usb/core/devio.c             |    2 +-
 scripts/spelling.txt                 |    1 +
 tools/perf/util/dso.c                |    2 +-
 5 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/s390/kernel/vtime.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances arch/s390/kernel/vtime.c
--- a/arch/s390/kernel/vtime.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances
+++ a/arch/s390/kernel/vtime.c
@@ -350,7 +350,7 @@ static void __add_vtimer(struct vtimer_l
 }
 
 /*
- * add_virt_timer - add an oneshot virtual CPU timer
+ * add_virt_timer - add a oneshot virtual CPU timer
  */
 void add_virt_timer(struct vtimer_list *timer)
 {
diff -puN drivers/net/ethernet/sfc/mcdi_pcol.h~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances drivers/net/ethernet/sfc/mcdi_pcol.h
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -10832,7 +10832,7 @@
 
 /***********************************/
 /* MC_CMD_GET_LICENSED_V3_FEATURE_STATES
- * Query the state of an one or more licensed features. (Note that the actual
+ * Query the state of one or more licensed features. (Note that the actual
  * state may be invalidated by the MC_CMD_LICENSING_V3 OP_UPDATE_LICENSE
  * operation or a reboot of the MC.) Used for V3 licensing (Medford)
  */
diff -puN drivers/usb/core/devio.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances
+++ a/drivers/usb/core/devio.c
@@ -2335,7 +2335,7 @@ static int proc_drop_privileges(struct u
 	if (copy_from_user(&data, arg, sizeof(data)))
 		return -EFAULT;
 
-	/* This is an one way operation. Once privileges are
+	/* This is a one way operation. Once privileges are
 	 * dropped, you cannot regain them. You may however reissue
 	 * this ioctl to shrink the allowed interfaces mask.
 	 */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -89,6 +89,7 @@ amout||amount
 an union||a union
 an user||a user
 an userspace||a userspace
+an one||a one
 analysator||analyzer
 ang||and
 anniversery||anniversary
diff -puN tools/perf/util/dso.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances tools/perf/util/dso.c
--- a/tools/perf/util/dso.c~scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances
+++ a/tools/perf/util/dso.c
@@ -951,7 +951,7 @@ static struct dso *__dso__findlink_by_lo
 		if (rc == 0) {
 			/*
 			 * In case the new DSO is a duplicate of an existing
-			 * one, print an one-time warning & put the new entry
+			 * one, print a one-time warning & put the new entry
 			 * at the end of the list of duplicates.
 			 */
 			if (!dso || (dso == this))
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

