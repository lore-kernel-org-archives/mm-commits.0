From: akpm@linux-foundation.org
Subject: + tpm_infineon-maintainer.patch added to -mm tree
Date: Thu, 15 Mar 2007 18:47:53 -0800
Message-ID: <200703160247.l2G2lrtO000815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbXCPCsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tpm@selhorst.net


The patch titled
     tpm_infineon: maintainer
has been added to the -mm tree.  Its filename is
     tpm_infineon-maintainer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tpm_infineon-maintainer.patch
tpm_infineon-add-support-for-devices-in-mmio-space.patch
