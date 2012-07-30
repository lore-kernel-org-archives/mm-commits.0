From: akpm@linux-foundation.org
Subject: [folded] vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:23:56 -0700
Message-ID: <20120730212357.5F2845C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:57599 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524Ab2G3VX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2012 17:23:59 -0400
Received: by lagr15 with SMTP id r15so245237lag.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:23:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrei.emeltchenko@intel.com, joe@perches.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/printk-formats.txt: add description for %pMR
has been removed from the -mm tree.  Its filename was
     vsprintf-add-%pmr-for-bluetooth-mac-address-fix.patch

This patch was dropped because it was folded into vsprintf-add-%pmr-for-bluetooth-mac-address.patch

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

Patches currently in -mm which might be from andrei.emeltchenko@intel.com are

origin.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch

