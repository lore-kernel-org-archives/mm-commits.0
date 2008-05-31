From: akpm@linux-foundation.org
Subject: + doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch added to -mm tree
Date: Fri, 30 May 2008 18:04:11 -0700
Message-ID: <200805310104.m4V14BXJ020506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYEaBEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 21:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, alan@lxorguk.ukuu.org.uk, rdunlap@xenotime.net


The patch titled
     doc: document the kernel-doc conventions for kernel hackers grammar fixes
has been added to the -mm tree.  Its filename is
     doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch

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
Subject: doc: document the kernel-doc conventions for kernel hackers grammar fixes
From: Paul Jackson <pj@sgi.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -4,14 +4,14 @@ kernel-doc nano-HOWTO
 How to format kernel-doc comments
 ---------------------------------
 
-In order to provide an embedded, 'C' friendly, easy to maintain,
+In order to provide embedded, 'C' friendly, easy to maintain,
 but consistent and extractable documentation of the functions and
 data structures in the Linux kernel, the Linux kernel has adopted
 a consistent style for documenting functions and their parameters,
 and structures and their members.
 
 The format for this documentation is called the kernel-doc format.
-It as documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
+It is documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
 
 This style embeds the documentation within the source files, using
 a few simple conventions.  The scripts/kernel-doc perl script, some
_

Patches currently in -mm which might be from pj@sgi.com are

cpusets-fix-and-update-documentation.patch
linux-next.patch
cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch

