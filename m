From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-update-tpm-driver-infrastructure-changes.patch removed from -mm
 tree
Date: Fri, 10 Nov 2017 14:21:53 -0800
Message-ID: <20171110222153.ltxqrmOpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754143AbdKJWVz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2017 17:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, ashleydlai@gmail.com, boris.brezillon@free-electrons.com, bp@suse.de, davem@davemloft.net, egtvedt@samfundet.no, geert@linux-m68k.org, gregkh@linuxfoundation.org, gwingerde@gmail.com, hskinnemoen@gmail.com, jarkko.sakkinen@linux.intel.com, martink@posteo.de, mchehab@kernel.org, mm-commits@vger.kernel.org, pavel@ucw.cz, rdunlap@infradead.org, tpmdd@selhorst.net, zohar@linux.vnet.ibm.com


The patch titled
     Subject: MAINTAINERS: update TPM driver infrastructure changes
has been removed from the -mm tree.  Its filename was
     maintainers-update-tpm-driver-infrastructure-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: MAINTAINERS: update TPM driver infrastructure changes

Link: http://lkml.kernel.org/r/20170915223811.21368-1-jarkko.sakkinen@linux.intel.com
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Ashley Lai <ashleydlai@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Håvard Skinnemoen <hskinnemoen@gmail.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    7 +++++++
 MAINTAINERS |   13 ++-----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff -puN CREDITS~maintainers-update-tpm-driver-infrastructure-changes CREDITS
--- a/CREDITS~maintainers-update-tpm-driver-infrastructure-changes
+++ a/CREDITS
@@ -4128,6 +4128,13 @@ D: MD driver
 D: EISA/sysfs subsystem
 S: France
 
+N: Marcel Selhorst
+E: tpmdd@selhorst.net
+D: TPM driver
+
+N: Ashley Lai
+E: ashleydlai@gmail.com
+D: IBM VTPM driver
 
 # Don't add your name here, unless you really _are_ after Marc
 # alphabetically. Leonard used to be very proud of being the 
diff -puN MAINTAINERS~maintainers-update-tpm-driver-infrastructure-changes MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tpm-driver-infrastructure-changes
+++ a/MAINTAINERS
@@ -13603,23 +13603,14 @@ F:	drivers/platform/x86/toshiba-wmi.c
 
 TPM DEVICE DRIVER
 M:	Peter Huewe <peterhuewe@gmx.de>
-M:	Marcel Selhorst <tpmdd@selhorst.net>
 M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
 R:	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
-W:	http://tpmdd.sourceforge.net
-L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
-Q:	https://patchwork.kernel.org/project/tpmdd-devel/list/
+L:	linux-integrity@vger.kernel.org
+Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
 S:	Maintained
 F:	drivers/char/tpm/
 
-TPM IBM_VTPM DEVICE DRIVER
-M:	Ashley Lai <ashleydlai@gmail.com>
-W:	http://tpmdd.sourceforge.net
-L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
-S:	Maintained
-F:	drivers/char/tpm/tpm_ibmvtpm*
