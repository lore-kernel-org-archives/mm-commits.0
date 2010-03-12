From: akpm@linux-foundation.org
Subject: + firmware-correct-attribution-of-sierra-wireless-cis-files.patch added to -mm tree
Date: Fri, 12 Mar 2010 12:35:39 -0800
Message-ID: <201003122035.o2CKZdoD006510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932683Ab0CLUgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 15:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, ken_kawasaki@spring.nifty.jp


The patch titled
     firmware: correct attribution of Sierra Wireless CIS files
has been added to the -mm tree.  Its filename is
     firmware-correct-attribution-of-sierra-wireless-cis-files.patch

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
Subject: firmware: correct attribution of Sierra Wireless CIS files
From: Ben Hutchings <ben@decadent.org.uk>

These files have nothing to do with the pcmcia-cs project and are
distributed without any clear licence.

The only source I can find for these files is
<http://www.sierrawireless.com/resources/faq/PC_Card/AirCard555/Aircard_Linux.tar> linked from <https://sierrawireless.custhelp.com/app/answers/detail/a_id/179/kw/linux>.

David Hinds who ran the pcmcia-cs project disclaims any knowledge of
these files.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/WHENCE |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN firmware/WHENCE~firmware-correct-attribution-of-sierra-wireless-cis-files firmware/WHENCE
--- a/firmware/WHENCE~firmware-correct-attribution-of-sierra-wireless-cis-files
+++ a/firmware/WHENCE
@@ -635,9 +635,6 @@ File: cis/MT5634ZLX.cis
       cis/RS-COM-2P.cis
       cis/COMpad2.cis
       cis/COMpad4.cis
-      cis/SW_555_SER.cis
-      cis/SW_7xx_SER.cis
-      cis/SW_8xx_SER.cis
 
 Licence: GPL
 
@@ -645,6 +642,18 @@ Originally developed by the pcmcia-cs pr
 
 --------------------------------------------------------------------------
 
+Driver: SERIAL_8250_CS - Serial PCMCIA adapter
+
+File: cis/SW_555_SER.cis
+File: cis/SW_7xx_SER.cis
+File: cis/SW_8xx_SER.cis
+
+Licence: Unknown
+
+Distributed by Sierra Wireless
+
+--------------------------------------------------------------------------
+
 Driver: PCMCIA_SMC91C92 - SMC 91Cxx PCMCIA
 
 File: ositech/Xilinx7OD.bin
_

Patches currently in -mm which might be from ben@decadent.org.uk are

video-fix-first-line-of-kernel-doc-for-a-few-functions.patch
linux-next.patch
firmware-correct-attribution-of-sierra-wireless-cis-files.patch
firmware-add-source-and-copyright-notice-for-cis-files-from-pcmcia-cs.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch

