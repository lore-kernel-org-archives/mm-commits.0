From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-__pmem-to-sparse-annotations.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:31 -0700
Message-ID: <55f3198f.UI/bp1PRzFqNCEeQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add __pmem to $Sparse annotations
has been removed from the -mm tree.  Its filename was
     checkpatch-add-__pmem-to-sparse-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add __pmem to $Sparse annotations

commit 61031952f4c8 ("arch, x86: pmem api for ensuring durability of
persistent memory updates") added a new __pmem annotation for sparse
verification.  Add __pmem to the $Sparse variable so checkpatch can
appropriately ignore uses of this attribute too.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-__pmem-to-sparse-annotations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-__pmem-to-sparse-annotations
+++ a/scripts/checkpatch.pl
@@ -264,6 +264,7 @@ our $Sparse	= qr{
 			__kernel|
 			__force|
 			__iomem|
+			__pmem|
 			__must_check|
 			__init_refok|
 			__kprobes|
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

