From: akpm@linux-foundation.org
Subject: + sky2-117.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:55:41 -0700
Message-ID: <200708242355.l7ONtfMv021188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbXHXX4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:56:16 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7ONtfS1004041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2007 16:55:42 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2 1.17
has been added to the -mm tree.  Its filename is
     sky2-117.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2 1.17
From: Stephen Hemminger <shemminger@linux-foundation.org>

Mark new version to track if current driver is in use.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-117 drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-117
+++ a/drivers/net/sky2.c
@@ -51,7 +51,7 @@
 #include "sky2.h"
 
 #define DRV_NAME		"sky2"
-#define DRV_VERSION		"1.16"
+#define DRV_VERSION		"1.17"
 #define PFX			DRV_NAME " "
 
 /*
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-clear-pci-power-control-reg-at-startup.patch
sky2-only-bring-up-watchdog-if-link-is-active.patch
sky2-117.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
