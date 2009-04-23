From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-typedefs.patch added to -mm tree
Date: Thu, 23 Apr 2009 14:32:26 -0700
Message-ID: <200904232132.n3NLWQlc025626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbZDWVfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 17:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl


The patch titled
     char: cyclades, remove typedefs
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-typedefs.patch

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
