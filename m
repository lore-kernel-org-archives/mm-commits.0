From: akpm@linux-foundation.org
Subject: + revert-maintainers-remove-invalid-list-address-for-tpm.patch added to -mm tree
Date: Mon, 14 May 2007 17:42:03 -0700
Message-ID: <200705150042.l4F0g3ge030313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbXEOAmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     Revert "MAINTAINERS: remove invalid list address for TPM"
has been added to the -mm tree.  Its filename is
     revert-maintainers-remove-invalid-list-address-for-tpm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN MAINTAINERS~revert-maintainers-remove-invalid-list-address-for-tpm MAINTAINERS
--- a/MAINTAINERS~revert-maintainers-remove-invalid-list-address-for-tpm
+++ a/MAINTAINERS
@@ -3269,6 +3269,7 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
+L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
 Telecom Clock Driver for MCPL0010
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

revert-maintainers-remove-invalid-list-address-for-tpm.patch
powerpc64-symbols-start-with.patch
