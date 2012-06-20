From: akpm@linux-foundation.org
Subject: + vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:20:04 -0700
Message-ID: <20120620212005.28A69A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51845 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2FTVUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:20:06 -0400
Received: by vbnl22 with SMTP id l22so778032vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:20:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrei.emeltchenko@intel.com, joe@perches.com, marcel@holtmann.org


The patch titled
     Subject: Documentation/printk-formats.txt: add description for %pMR
has been added to the -mm tree.  Its filename is
     vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Subject: Documentation/printk-formats.txt: add description for %pMR

Add information about new specifier %pMR for Bluetooth addresses.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/printk-formats.txt~vsprintf-add-%pmr-for-bluetooth-mac-address-fix Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~vsprintf-add-%pmr-for-bluetooth-mac-address-fix
+++ a/Documentation/printk-formats.txt
@@ -56,6 +56,7 @@ Struct Resources:
 MAC/FDDI addresses:
 
 	%pM	00:01:02:03:04:05
+	%pMR	05:04:03:02:01:00
 	%pMF	00-01-02-03-04-05
 	%pm	000102030405
 
@@ -67,6 +68,10 @@ MAC/FDDI addresses:
 	the 'M' specifier to use dash ('-') separators instead of the default
 	separator.
 
+	For Bluetooth addresses the 'R' specifier shall be used after the 'M'
+	specifier to use reversed byte order suitable for visual interpretation
+	of Bluetooth addresses which are in the little endian order.
+
 IPv4 addresses:
 
 	%pI4	1.2.3.4
_
Subject: Subject: Documentation/printk-formats.txt: add description for %pMR

Patches currently in -mm which might be from andrei.emeltchenko@intel.com are

linux-next.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch
vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch

