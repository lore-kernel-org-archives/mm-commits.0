From: akpm@linux-foundation.org
Subject: + char-mxser_new-remove-useless-comments-in-mxser_cards.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:31:48 -0700
Message-ID: <200708152131.l7FLVmm7016025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbXHOVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, remove useless comments in mxser_cards
has been added to the -mm tree.  Its filename is
     char-mxser_new-remove-useless-comments-in-mxser_cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, remove useless comments in mxser_cards
From: Jiri Slaby <jirislaby@gmail.com>

mxser_new, remove useless comments in mxser_cards

It was rest from times, where info about the card was separated (name,
ports number and flags).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   42 ++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-remove-useless-comments-in-mxser_cards drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-remove-useless-comments-in-mxser_cards
+++ a/drivers/char/mxser_new.c
@@ -113,29 +113,29 @@ struct mxser_cardinfo {
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-/* 0*/	{ 8, "C168 series", },			/* C168-ISA */
-	{ 4, "C104 series", },			/* C104-ISA */
-	{ 4, "CI-104J series", },		/* CI104J */
-	{ 8, "C168H/PCI series", },		/* C168-PCI */
-	{ 4, "C104H/PCI series", },		/* C104-PCI */
+/* 0*/	{ 8, "C168 series", },
+	{ 4, "C104 series", },
+	{ 4, "CI-104J series", },
+	{ 8, "C168H/PCI series", },
+	{ 4, "C104H/PCI series", },
 /* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
-	{ 4, "CI-132 series", MXSER_HAS2 },	/* CI132 */
-	{ 4, "CI-134 series", },		/* CI134 */
-	{ 2, "CP-132 series", },		/* CP132 */
-	{ 4, "CP-114 series", },		/* CP114 */
-/*10*/	{ 4, "CT-114 series", },		/* CT114 */
-	{ 2, "CP-102 series", MXSER_HIGHBAUD },	/* CP102 */
-	{ 4, "CP-104U series", },		/* CP104U */
-	{ 8, "CP-168U series", },		/* CP168U */
-	{ 2, "CP-132U series", },		/* CP132U */
-/*15*/	{ 4, "CP-134U series", },		/* CP134U */
-	{ 4, "CP-104JU series", },		/* CP104JU */
+	{ 4, "CI-132 series", MXSER_HAS2 },
+	{ 4, "CI-134 series", },
+	{ 2, "CP-132 series", },
+	{ 4, "CP-114 series", },
+/*10*/	{ 4, "CT-114 series", },
+	{ 2, "CP-102 series", MXSER_HIGHBAUD },
+	{ 4, "CP-104U series", },
+	{ 8, "CP-168U series", },
+	{ 2, "CP-132U series", },
+/*15*/	{ 4, "CP-134U series", },
+	{ 4, "CP-104JU series", },
 	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
-	{ 8, "CP-118U series", },		/* CP118U */
-	{ 2, "CP-102UL series", },		/* CP102UL */
-/*20*/	{ 2, "CP-102U series", },		/* CP102U */
-	{ 8, "CP-118EL series", },		/* CP118EL */
-	{ 8, "CP-168EL series", },		/* CP168EL */
+	{ 8, "CP-118U series", },
+	{ 2, "CP-102UL series", },
+/*20*/	{ 2, "CP-102U series", },
+	{ 8, "CP-118EL series", },
+	{ 8, "CP-168EL series", },
 	{ 4, "CP-104EL series", },
 	{ 8, "CB-108 series", },
 /*25*/	{ 4, "CB-114 series", },
_

Patches currently in -mm which might be from jirislaby@gmail.com are

epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
