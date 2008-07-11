From: akpm@linux-foundation.org
Subject: + tpm-add-support-for-broadcom-tpm-tis-device-hid.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:36:31 -0700
Message-ID: <200807111842.m6BIgCdC030652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbYGKSnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eledisez@grounation.org, srajiv@linux.vnet.ibm.com, tpm@selhorst.net


The patch titled
     tpm: add support for Broadcom TPM TIS device HID
has been added to the -mm tree.  Its filename is
     tpm-add-support-for-broadcom-tpm-tis-device-hid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tpm-add-support-for-broadcom-tpm-tis-device-hid.patch

