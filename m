From: akpm@linux-foundation.org
Subject: + rapidio-fix-typos-and-minor-edits.patch added to -mm tree
Date: Tue, 04 May 2010 16:25:09 -0700
Message-ID: <201005042325.o44NPAkI025139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934634Ab0EDXZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: fix typos and minor edits
has been added to the -mm tree.  Its filename is
     rapidio-fix-typos-and-minor-edits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix typos and minor edits
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c            |    1 -
 drivers/rapidio/switches/Kconfig |    8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-typos-and-minor-edits drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-typos-and-minor-edits
+++ a/drivers/rapidio/rio.c
@@ -445,7 +445,6 @@ static struct rio_dev *rio_get_comptag(u
 	struct list_head *n;
 	struct rio_dev *rdev;
 
-	WARN_ON(in_interrupt());
 	spin_lock(&rio_global_list_lock);
 	n = from ? from->global_list.next : rio_devices.next;
 
diff -puN drivers/rapidio/switches/Kconfig~rapidio-fix-typos-and-minor-edits drivers/rapidio/switches/Kconfig
--- a/drivers/rapidio/switches/Kconfig~rapidio-fix-typos-and-minor-edits
+++ a/drivers/rapidio/switches/Kconfig
@@ -5,24 +5,24 @@ config RAPIDIO_TSI57X
 	bool "IDT Tsi57x SRIO switches support"
 	depends on RAPIDIO
 	---help---
-	  Includes support for ITD Tsi57x family of serial RapidIO switches.
+	  Includes support for IDT Tsi57x family of serial RapidIO switches.
 
 config RAPIDIO_CPS_XX
 	bool "IDT CPS-xx SRIO switches support"
 	depends on RAPIDIO
 	---help---
-	  Includes support for ITD CPS-16/12/10/8 serial RapidIO switches.
+	  Includes support for IDT CPS-16/12/10/8 serial RapidIO switches.
 
 config RAPIDIO_TSI568
 	bool "Tsi568 SRIO switch support"
 	depends on RAPIDIO
 	default n
 	---help---
-	  Includes support for ITD Tsi568 serial RapidIO switch.
+	  Includes support for IDT Tsi568 serial RapidIO switch.
 
 config RAPIDIO_TSI500
 	bool "Tsi500 Parallel RapidIO switch support"
 	depends on RAPIDIO
 	default n
 	---help---
-	  Includes support for ITD Tsi500 parallel RapidIO switch.
+	  Includes support for IDT Tsi500 parallel RapidIO switch.
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-fix-typos-and-minor-edits.patch
rapidio-add-debug-configuration-option.patch
rapidio-modify-initialization-of-switch-operations.patch
rapidio-add-switch-domain-routines.patch
rapidio-use-default-route-value-for-cps-switches.patch

