From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-remove-typedefs.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:18:09 -0700
Message-ID: <200904291918.n3TJI9k3030961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbZD2TUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, remove typedefs
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-typedefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, remove typedefs
From: Jiri Slaby <jirislaby@gmail.com>

They are unused anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cyclades.h |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN include/linux/cyclades.h~char-cyclades-remove-typedefs include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-typedefs
+++ a/include/linux/cyclades.h
@@ -142,19 +142,6 @@ struct CYZ_BOOT_CTRL {
 
 
 #ifndef DP_WINDOW_SIZE
-/* #include "cyclomz.h" */
-/****************** ****************** *******************/
-/*
- *	The data types defined below are used in all ZFIRM interface
- *	data structures. They accomodate differences between HW
- *	architectures and compilers.
- */
-
-typedef __u64  ucdouble;		/* 64 bits, unsigned */
-typedef __u32  uclong;			/* 32 bits, unsigned */
-typedef __u16  ucshort;		/* 16 bits, unsigned */
-typedef __u8   ucchar;			/* 8 bits, unsigned */
