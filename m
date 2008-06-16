From: akpm@linux-foundation.org
Subject: - driver-char-generic_nvram-fix-banner.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:52 -0700
Message-ID: <200806160603.m5G63qR6010629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbYFPGD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, arjan@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     driver/char/generic_nvram: fix banner
has been removed from the -mm tree.  Its filename was
     driver-char-generic_nvram-fix-banner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver/char/generic_nvram: fix banner
From: Philippe De Muyter <phdm@macqel.be>

The generic nvram driver announces itself as
	'Macintosh non-volatile memory driver'
instead of 'Generic non-volatile memory driver'.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/generic_nvram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/generic_nvram.c~driver-char-generic_nvram-fix-banner drivers/char/generic_nvram.c
--- a/drivers/char/generic_nvram.c~driver-char-generic_nvram-fix-banner
+++ a/drivers/char/generic_nvram.c
@@ -133,7 +133,7 @@ static struct miscdevice nvram_dev = {
 
 int __init nvram_init(void)
 {
-	printk(KERN_INFO "Macintosh non-volatile memory driver v%s\n",
+	printk(KERN_INFO "Generic non-volatile memory driver v%s\n",
 		NVRAM_VERSION);
 	return misc_register(&nvram_dev);
 }
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

