From: akpm@linux-foundation.org
Subject: - doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch removed from -mm tree
Date: Thu, 05 Jun 2008 21:00:29 -0700
Message-ID: <200806060400.m5640TYu012238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbYFFEAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 00:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, alan@lxorguk.ukuu.org.uk, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     doc: document the kernel-doc conventions for kernel hackers grammar fixes
has been removed from the -mm tree.  Its filename was
     doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch

This patch was dropped because it was folded into doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch

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
doc-update-to-url-and-status-of-kernel-docstxt-entry.patch
cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers-grammar-fixes.patch

