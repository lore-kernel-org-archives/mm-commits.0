From: akpm@linux-foundation.org
Subject: - fix-chapter-reference-in-codingstyle.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:35 -0700
Message-ID: <200705090251.l492pZrk009475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032186AbXEICvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix chapter reference in CodingStyle
has been removed from the -mm tree.  Its filename was
     fix-chapter-reference-in-codingstyle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix chapter reference in CodingStyle
From: Jesper Juhl <jesper.juhl@gmail.com>

commit 226a6b84aaaf1fac7a5d41cf4e7387fd9ba895d5 renumbered Chapter 11 in
Documentation/CodingStyle to Chapter 12, but it didn't update the reference
to that chapter further down in the file.  This patch corrects the chapter
reference.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/CodingStyle~fix-chapter-reference-in-codingstyle Documentation/CodingStyle
--- a/Documentation/CodingStyle~fix-chapter-reference-in-codingstyle
+++ a/Documentation/CodingStyle
@@ -640,7 +640,7 @@ language.
 
 There appears to be a common misperception that gcc has a magic "make me
 faster" speedup option called "inline". While the use of inlines can be
-appropriate (for example as a means of replacing macros, see Chapter 11), it
+appropriate (for example as a means of replacing macros, see Chapter 12), it
 very often is not. Abundant use of the inline keyword leads to a much bigger
 kernel, which in turn slows the system as a whole down, due to a bigger
 icache footprint for the CPU and simply because there is less memory
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
