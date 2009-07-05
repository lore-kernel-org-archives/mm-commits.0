From: akpm@linux-foundation.org
Subject: [merged] comedi-jr3_pcic-add-required-includes.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:35:37 -0700
Message-ID: <200907051835.n65IZbH2004469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZGESfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     comedi: jr3_pci.c: add required includes
has been removed from the -mm tree.  Its filename was
     comedi-jr3_pcic-add-required-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: comedi: jr3_pci.c: add required includes
From: Alexander Beregalov <a.beregalov@gmail.com>

jr3_pci.c:739: error: 'jiffies' undeclared
jr3_pci.c:748: error: implicit declaration of function 'msecs_to_jiffies'
jr3_pci.c:763: error: implicit declaration of function 'add_timer'
jr3_pci.c:790: error: implicit declaration of function 'init_timer'
jr3_pci.c:951: error: implicit declaration of function 'del_timer_sync'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/jr3_pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/staging/comedi/drivers/jr3_pci.c~staging-comedi-jr3_pcic-add-required-includes drivers/staging/comedi/drivers/jr3_pci.c
--- a/drivers/staging/comedi/drivers/jr3_pci.c~staging-comedi-jr3_pcic-add-required-includes
+++ a/drivers/staging/comedi/drivers/jr3_pci.c
@@ -45,6 +45,8 @@ Devices: [JR3] PCI force sensor board (j
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
 #include "comedi_pci.h"
 #include "jr3_pci.h"
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
vt6655-s-void-void.patch
staging-otus-remove-dependency-on-wireless_ext-version.patch
staging-rt2860-remove-dependency-on-wireless_ext-version.patch

