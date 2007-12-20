From: akpm@linux-foundation.org
Subject: - iscsi-project-page-changed.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:01 -0800
Message-ID: <200712202338.lBKNc19A018946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXLTXri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     iscsi project page changed
has been removed from the -mm tree.  Its filename was
     iscsi-project-page-changed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: iscsi project page changed
From: <crquan@gmail.com>

There's a merging news happened two years ago:

	http://www.open-iscsi.org/

	Linux-iSCSI(sfnet) and Open-iSCSI projects merged!(April 11, 2005)
	http://marc.theaimsgroup.com/?l=linux-kernel&m=111327337005048&w=2

so the information should change,

and there are needs about iscsi documentation under Documentation/scsi/,
or just some links to the documents on the website.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~iscsi-project-page-changed drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~iscsi-project-page-changed
+++ a/drivers/scsi/Kconfig
@@ -341,7 +341,7 @@ config ISCSI_TCP
 	 The userspace component needed to initialize the driver, documentation,
 	 and sample configuration files can be found here:
 
-	 http://linux-iscsi.sf.net
+	 http://www.open-iscsi.org/
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
git-md-accel.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch
