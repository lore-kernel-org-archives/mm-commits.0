From: akpm@linux-foundation.org
Subject: - tpm_infineon-maintainer.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:02 -0800
Message-ID: <200703180910.l2I9A26h020060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXCRJKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm_infineon: maintainer
has been removed from the -mm tree.  Its filename was
     tpm_infineon-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tpm_infineon: maintainer
From: Marcel Selhorst <tpm@selhorst.net>

Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~tpm_infineon-maintainer MAINTAINERS
--- a/MAINTAINERS~tpm_infineon-maintainer
+++ a/MAINTAINERS
@@ -3103,6 +3103,9 @@ TPM DEVICE DRIVER
 P:	Kylene Hall
 M:	kjhall@us.ibm.com
 W:	http://tpmdd.sourceforge.net
+P:	Marcel Selhorst
+M:	tpm@selhorst.net
+W:	http://www.prosec.rub.de/tpm/
 L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
_

Patches currently in -mm which might be from tpm@selhorst.net are

origin.patch
tpm_infineon-add-support-for-devices-in-mmio-space.patch
