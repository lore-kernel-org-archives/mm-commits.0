From: akpm@linux-foundation.org
Subject: + writeback-fix-missing-kernel-doc-notation.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:35:12 -0800
Message-ID: <200911242035.nAOKZCHr010586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757601AbZKXUgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:36:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, fengguang.wu@intel.com, jaswinderrajput@gmail.com, randy.dunlap@oracle.com


The patch titled
     writeback: fix missing kernel-doc notation
has been added to the -mm tree.  Its filename is
     writeback-fix-missing-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
mm-includecheck-fix-slqb.patch
writeback-fix-missing-kernel-doc-notation.patch
pm-fix-kernel-doc-notation.patch

