From: akpm@linux-foundation.org
Subject: - tpm-add-support-for-broadcom-tpm-tis-device-hid.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:51 -0700
Message-ID: <200807262113.m6QLDpoq019631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbYGZVOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eledisez@grounation.org, srajiv@linux.vnet.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: add support for Broadcom TPM TIS device HID
has been removed from the -mm tree.  Its filename was
     tpm-add-support-for-broadcom-tpm-tis-device-hid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: add support for Broadcom TPM TIS device HID
From: LE DISEZ Erwan <eledisez@grounation.org>

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/tpm/tpm_tis.c~tpm-add-support-for-broadcom-tpm-tis-device-hid drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-add-support-for-broadcom-tpm-tis-device-hid
+++ a/drivers/char/tpm/tpm_tis.c
@@ -622,6 +622,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"ATM1200", 0},		/* Atmel */
 	{"IFX0102", 0},		/* Infineon */
 	{"BCM0101", 0},		/* Broadcom */
+	{"BCM0102", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
 	{"ICO0102", 0},		/* Intel */
 	/* Add new here */
_

Patches currently in -mm which might be from eledisez@grounation.org are

origin.patch

