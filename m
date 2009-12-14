From: akpm@linux-foundation.org
Subject: [merged] writeback-fix-missing-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:33 -0800
Message-ID: <200912142123.nBELNXNE016933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933071AbZLNVYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:24:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, fengguang.wu@intel.com, jaswinderrajput@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     writeback: fix missing kernel-doc notation
has been removed from the -mm tree.  Its filename was
     writeback-fix-missing-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: fix missing kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following htmldocs warning:

  Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fs-writeback.c~writeback-fix-missing-kernel-doc-notation fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-missing-kernel-doc-notation
+++ a/fs/fs-writeback.c
@@ -242,6 +242,7 @@ static void bdi_sync_writeback(struct ba
 /**
  * bdi_start_writeback - start writeback
  * @bdi: the backing device to write from
+ * @sb: write inodes from this super_block
  * @nr_pages: the number of pages to write
  *
  * Description:
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch

