From: akpm@linux-foundation.org
Subject: + i2c-i801-documentation-patch-for-intel-tolapai.patch added to -mm tree
Date: Mon, 10 Sep 2007 02:41:13 -0700
Message-ID: <200709100941.l8A9fDnF017703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbXIJJl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 05:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com, khali@linux-fr.org


The patch titled
     i2c-i801: Documentation patch for Intel Tolapai
has been added to the -mm tree.  Its filename is
     i2c-i801-documentation-patch-for-intel-tolapai.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c-i801: Documentation patch for Intel Tolapai
From: Jason Gaston <jason.d.gaston@intel.com>

This patch adds the Intel Tolapai SMBus Controller text to i2c-i801
documentation.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i2c/busses/i2c-i801 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/i2c/busses/i2c-i801~i2c-i801-documentation-patch-for-intel-tolapai Documentation/i2c/busses/i2c-i801
--- a/Documentation/i2c/busses/i2c-i801~i2c-i801-documentation-patch-for-intel-tolapai
+++ a/Documentation/i2c/busses/i2c-i801
@@ -13,7 +13,8 @@ Supported adapters:
   * Intel 631xESB/632xESB (ESB2)
   * Intel 82801H (ICH8)
   * Intel ICH9
-    Datasheets: Publicly available at the Intel website
+  * Intel Tolapai
+   Datasheets: Publicly available at the Intel website
 
 Authors: 
 	Frodo Looijaard <frodol@dds.nl>, 
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

irq-irq-and-pci_ids-patch-for-intel-tolapai.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
ata_piix-ide-mode-sata-patch-for-intel-tolapai.patch
ahci-raid-mode-sata-patch-for-intel-tolapai.patch
