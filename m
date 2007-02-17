From: akpm@linux-foundation.org
Subject: + sk98lin-planned-removal.patch added to -mm tree
Date: Fri, 16 Feb 2007 17:26:56 -0800
Message-ID: <200702170126.l1H1QuOi015724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946285AbXBQB05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:26:57 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1H1QuhB014095
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 16 Feb 2007 17:26:56 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sk98lin: planned removal
has been added to the -mm tree.  Its filename is
     sk98lin-planned-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sk98lin: planned removal
From: Stephen Hemminger <shemminger@linux-foundation.org>

Nag message about planned sk98lin removal.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sk98lin/skge.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/net/sk98lin/skge.c~sk98lin-planned-removal drivers/net/sk98lin/skge.c
--- a/drivers/net/sk98lin/skge.c~sk98lin-planned-removal
+++ a/drivers/net/sk98lin/skge.c
@@ -5188,6 +5188,9 @@ static struct pci_driver skge_driver = {
 
 static int __init skge_init(void)
 {
+	printk(KERN_NOTICE "sk98lin: driver has been replaced by the skge driver"
+	       " and is scheduled for removal\n");
+
 	return pci_register_driver(&skge_driver);
 }
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
sk98lin-planned-removal.patch
