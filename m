From: akpm@linux-foundation.org
Subject: - revert-maintainers-remove-invalid-list-address-for-tpm.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:18 -0700
Message-ID: <200705151807.l4FI7HM9014156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbXEOSHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     Revert "MAINTAINERS: remove invalid list address for TPM"
has been removed from the -mm tree.  Its filename was
     revert-maintainers-remove-invalid-list-address-for-tpm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert "MAINTAINERS: remove invalid list address for TPM"
From: Stephen Rothwell <sfr@canb.auug.org.au>

This reverts commit b6d1c9a44744224d83125a5a89c1a6cc4db27361.

Others tell me that this address has worked for them, so I can only
assume that I hit a glitch in the sourceforge mail system.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~revert-maintainers-remove-invalid-list-address-for-tpm MAINTAINERS
--- a/MAINTAINERS~revert-maintainers-remove-invalid-list-address-for-tpm
+++ a/MAINTAINERS
@@ -3267,6 +3267,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
+L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
 Telecom Clock Driver for MCPL0010
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
powerpc64-symbols-start-with.patch
