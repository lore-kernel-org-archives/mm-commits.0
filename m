From: akpm@linux-foundation.org
Subject: - tpm-add-intel-tpm-tis-device-hid.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:28 -0700
Message-ID: <200807112350.m6BNoSCN010962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbYGKXvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin_obara@users.sourceforge.net, srajiv@linux.vnet.ibm.com, stable@kernel.org, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: add Intel TPM TIS device HID
has been removed from the -mm tree.  Its filename was
     tpm-add-intel-tpm-tis-device-hid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: add Intel TPM TIS device HID
From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch adds Intel TPM TIS device HID:  ICO0102

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Acked-by: Marcel Selhorst <tpm@selhorst.net>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/tpm/tpm_tis.c~tpm-add-intel-tpm-tis-device-hid drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-add-intel-tpm-tis-device-hid
+++ a/drivers/char/tpm/tpm_tis.c
@@ -623,6 +623,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"IFX0102", 0},		/* Infineon */
 	{"BCM0101", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
+	{"ICO0102", 0},		/* Intel */
 	/* Add new here */
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
_

Patches currently in -mm which might be from marcin_obara@users.sourceforge.net are

origin.patch
tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch

