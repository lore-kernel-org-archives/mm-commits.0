From: akpm@linux-foundation.org
Subject: + libata-fix-kernel-doc-param-name.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:49:17 -0700
Message-ID: <200710182149.l9ILnHsN032741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757888AbXJRVuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     libata: fix kernel-doc param name
has been added to the -mm tree.  Its filename is
     libata-fix-kernel-doc-param-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: fix kernel-doc param name
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix libata kernel-doc parameter name.

Warning(linux-2.6.23-git13//drivers/ata/libata-core.c:1415): No description found for parameter 'sgl'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~libata-fix-kernel-doc-param-name drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-kernel-doc-param-name
+++ a/drivers/ata/libata-core.c
@@ -1392,7 +1392,7 @@ static void ata_qc_complete_internal(str
  *	@tf: Taskfile registers for the command and the result
  *	@cdb: CDB for packet command
  *	@dma_dir: Data tranfer direction of the command
- *	@sg: sg list for the data buffer of the command
+ *	@sgl: sg list for the data buffer of the command
  *	@n_elem: Number of sg entries
  *	@timeout: Timeout in msecs (0 for default)
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
i-oat-cleanup-pci-issues.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
libata-fix-kernel-doc-param-name.patch
onenand-sim-fix-kernel-doc-and-typos.patch
git-net.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kernel-api-docbook-fix-content-problems.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
