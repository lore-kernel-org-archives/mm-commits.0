From: akpm@linux-foundation.org
Subject: + drivers-misc-eeprom_93cx6c-remove-include-versionh.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:30:05 -0700
Message-ID: <200808211930.m7LJU5nD021938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431AbYHUTad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com


The patch titled
     drivers/misc/eeprom_93cx6.c: remove #include <version.h>
has been added to the -mm tree.  Its filename is
     drivers-misc-eeprom_93cx6c-remove-include-versionh.patch

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
Subject: drivers/misc/eeprom_93cx6.c: remove #include <version.h>
From: Huang Weiyi <weiyi.huang@gmail.com>

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom_93cx6.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/eeprom_93cx6.c~drivers-misc-eeprom_93cx6c-remove-include-versionh drivers/misc/eeprom_93cx6.c
--- a/drivers/misc/eeprom_93cx6.c~drivers-misc-eeprom_93cx6c-remove-include-versionh
+++ a/drivers/misc/eeprom_93cx6.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/eeprom_93cx6.h>
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-x86-kernel-apm_32c-remove-duplicated-include.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch
drivers-misc-eeprom_93cx6c-remove-include-versionh.patch

