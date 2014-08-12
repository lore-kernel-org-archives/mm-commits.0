From: akpm@linux-foundation.org
Subject: [merged]
 scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:42 -0700
Message-ID: <53ea6df6.i1AuDEVZFJlaOzHZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:62686 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaHLTln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:43 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1069828igi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Julia.Lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/coccinelle/free/ifnullfree.cocci: add copyright information
has been removed from the -mm tree.  Its filename was
     scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: scripts/coccinelle/free/ifnullfree.cocci: add copyright information

All coccinelle scripts have a copyright in the header.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/free/ifnullfree.cocci |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/coccinelle/free/ifnullfree.cocci~scripts-coccinelle-free-ifnullfreecocci-add-copyright-information scripts/coccinelle/free/ifnullfree.cocci
--- a/scripts/coccinelle/free/ifnullfree.cocci~scripts-coccinelle-free-ifnullfreecocci-add-copyright-information
+++ a/scripts/coccinelle/free/ifnullfree.cocci
@@ -4,8 +4,9 @@
 /// "kfree(NULL) is safe this check is probably not required"
 /// and kfreeaddr.cocci by Julia Lawall.
 ///
-/// Comments: -
-/// Options: --no-includes --include-headers
+// Copyright: (C) 2014 Fabian Frederick.  GPLv2.
+// Comments: -
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual org
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

