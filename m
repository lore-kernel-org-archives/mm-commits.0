From: akpm@linux-foundation.org
Subject: + maintainers-remove-invalid-list-address-for-tpm.patch added to -mm tree
Date: Fri, 11 May 2007 12:43:47 -0700
Message-ID: <200705111943.l4BJhlF4024893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763574AbXEKToM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     MAINTAINERS: remove invalid list address for TPM
has been added to the -mm tree.  Its filename is
     maintainers-remove-invalid-list-address-for-tpm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: remove invalid list address for TPM
From: Stephen Rothwell <sfr@canb.auug.org.au>

This address bounces with "550 Unknown user".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 files changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-invalid-list-address-for-tpm MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-invalid-list-address-for-tpm
+++ a/MAINTAINERS
@@ -3319,7 +3319,6 @@ W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
-L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
 
 Telecom Clock Driver for MCPL0010
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
consolidate-asm-pollh.patch
missing-include-file-in-tpm_atmelh.patch
maintainers-remove-invalid-list-address-for-tpm.patch
powerpc64-symbols-start-with.patch
