From: akpm@linux-foundation.org
Subject: [merged] tpm-increase-default-tpm-buffer.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:51 -0700
Message-ID: <200909251953.n8PJrp2v003797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbZIYTxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: increase default TPM buffer
has been removed from the -mm tree.  Its filename was
     tpm-increase-default-tpm-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: increase default TPM buffer
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

The TPM Working Group requested this communication buffer increase given
that a particular TPM vendor can support a TPM_SHA1Start command input
bigger than the current size.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm.c~tpm-increase-default-tpm-buffer drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-increase-default-tpm-buffer
+++ a/drivers/char/tpm/tpm.c
@@ -31,7 +31,7 @@
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 2048,
+	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
 };
 
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

origin.patch
linux-next.patch

