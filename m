From: akpm@linux-foundation.org
Subject: [patch 2/2] MAINTAINERS: update TPM driver infrastructure changes
Date: Thu, 09 Nov 2017 13:38:21 -0800
Message-ID: <5a04cacd.rpTgYwwkVEyNw+VU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdKIViX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2017 16:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jarkko.sakkinen@linux.intel.com, acme@kernel.org, ashleydlai@gmail.com, boris.brezillon@free-electrons.com, bp@suse.de, davem@davemloft.net, egtvedt@samfundet.no, geert@linux-m68k.org, gregkh@linuxfoundation.org, gwingerde@gmail.com, hskinnemoen@gmail.com, martink@posteo.de, mchehab@kernel.org, pavel@ucw.cz, rdunlap@infradead.org, tpmdd@selhorst.net, zohar@linux.vnet.ibm.com

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: MAINTAINERS: update TPM driver infrastructure changes

[akpm@linux-foundation.org: alpha-sort CREDITS, per Randy]
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

 CREDITS     |    9 ++++++++-
 MAINTAINERS |   13 ++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff -puN CREDITS~maintainers-update-tpm-driver-infrastructure-changes CREDITS
--- a/CREDITS~maintainers-update-tpm-driver-infrastructure-changes
+++ a/CREDITS
@@ -2113,6 +2113,10 @@ S: J. Obrechtstr 23
 S: NL-5216 GP 's-Hertogenbosch
 S: The Netherlands
 
+N: Ashley Lai
+E: ashleydlai@gmail.com
+D: IBM VTPM driver
+
 N: Savio Lam
 E: lam836@cs.cuhk.hk
 D: Author of the dialog utility, foundation
@@ -3333,6 +3337,10 @@ S: Braunschweiger Strasse 79
 S: 31134 Hildesheim
 S: Germany
 
+N: Marcel Selhorst
+E: tpmdd@selhorst.net
+D: TPM driver
+
 N: Darren Senn
 E: sinster@darkwater.com
 D: Whatever I notice needs doing (so far: itimers, /proc)
@@ -4128,7 +4136,6 @@ D: MD driver
 D: EISA/sysfs subsystem
 S: France
 
-
 # Don't add your name here, unless you really _are_ after Marc
 # alphabetically. Leonard used to be very proud of being the 
 # last entry, and he'll get positively pissed if he can't even
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
