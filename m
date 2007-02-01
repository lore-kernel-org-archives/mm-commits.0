From: akpm@osdl.org
Subject: + mtd-add-missing-kernel-doc-item.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:30:59 -0800
Message-ID: <200702012230.l11MUxBF024846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbXBAWbE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:31:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     MTD: add missing kernel-doc item
has been added to the -mm tree.  Its filename is
     mtd-add-missing-kernel-doc-item.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: add missing kernel-doc item
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning in mtd/nand.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mtd/nand.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/mtd/nand.h~mtd-add-missing-kernel-doc-item include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~mtd-add-missing-kernel-doc-item
+++ a/include/linux/mtd/nand.h
@@ -343,6 +343,7 @@ struct nand_buffers {
  * @options:		[BOARDSPECIFIC] various chip options. They can partly be set to inform nand_scan about
  *			special functionality. See the defines for further explanation
  * @badblockpos:	[INTERN] position of the bad block marker in the oob area
+ * @cellinfo:		MLC/multichip data (newer devices have more ID bytes)
  * @numchips:		[INTERN] number of physical chips
  * @chipsize:		[INTERN] the size of one chip for multichip arrays
  * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

sysrq-showblockedtasks-is-sysrq-w.patch
git-alsa.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
mtd-add-missing-kernel-doc-item.patch
git-net.patch
git-ocfs2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
