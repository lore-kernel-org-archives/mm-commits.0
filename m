From: akpm@linux-foundation.org
Subject: - ibm_newemac-mal_ier_events-definition-2x-_ote-_de.patch removed from -mm tree
Date: Thu, 04 Sep 2008 12:56:11 -0700
Message-ID: <200809041956.m84JuBPL027860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbYIDT4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 15:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au, mm-commits@vger.kernel.org


The patch titled
     ibm_newemac: MAL[12]_IER_EVENTS definition: 2x *_OTE -> *_DE
has been removed from the -mm tree.  Its filename was
     ibm_newemac-mal_ier_events-definition-2x-_ote-_de.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibm_newemac: MAL[12]_IER_EVENTS definition: 2x *_OTE -> *_DE
From: roel kluin <roel.kluin@gmail.com>

MAL[12]_IER_EVENTS definitions have MAL_IER_OTE twice but lack MAL_IER_DE

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibm_newemac/mal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ibm_newemac/mal.h~ibm_newemac-mal_ier_events-definition-2x-_ote-_de drivers/net/ibm_newemac/mal.h
--- a/drivers/net/ibm_newemac/mal.h~ibm_newemac-mal_ier_events-definition-2x-_ote-_de
+++ a/drivers/net/ibm_newemac/mal.h
@@ -102,7 +102,7 @@
 /* MAL V1 IER bits */
 #define   MAL1_IER_NWE		0x00000008
 #define   MAL1_IER_SOC_EVENTS	MAL1_IER_NWE
-#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_OTE | \
+#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_DE | \
 				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
 /* MAL V2 IER bits */
@@ -110,7 +110,7 @@
 #define   MAL2_IER_PRE		0x00000040
 #define   MAL2_IER_PWE		0x00000020
 #define   MAL2_IER_SOC_EVENTS	(MAL2_IER_PT | MAL2_IER_PRE | MAL2_IER_PWE)
-#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_OTE | \
+#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_DE | \
 				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
altix-serial-fix.patch

