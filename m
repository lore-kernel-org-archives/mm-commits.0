From: akpm@linux-foundation.org
Subject: + include-linux-kernelh-remove-labs.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:19:41 -0800
Message-ID: <200702052119.l15LJf1E031468@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933465AbXBEVWx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:22:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     include/linux/kernel.h: Remove labs()
has been added to the -mm tree.  Its filename is
     include-linux-kernelh-remove-labs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: include/linux/kernel.h: Remove labs()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Remove labs() since it is not used/needed.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 -----
 1 files changed, 5 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-remove-labs include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-remove-labs
+++ a/include/linux/kernel.h
@@ -92,11 +92,6 @@ extern int cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#define labs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

drivers-media-video-convert-to-generic-boolean-values.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
include-linux-kernelh-remove-labs.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
drivers-video-sis-convert-to-generic-boolean.patch
